//
//  VPClient.m
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import "VPClient.h"

@interface VPClient () <NSStreamDelegate>
{
	NSInputStream *inputStream;
	NSOutputStream *outputStream;
	
	NSMutableData *toSend;
	NSMutableData *receiveBuffer;
}

- (void)sendLine:(NSString *)line;
- (void)parseLine:(NSString *)line;

- (void)parseReceivedData;
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent;

@end

@implementation VPClient

- (id)initWithNetService:(NSNetService *)service userName:(NSString *)userName
{
	CFWriteStreamRef writeStream = NULL;
	CFReadStreamRef readStream = NULL;
	
	CFStreamCreatePairWithSocketToNetService(kCFAllocatorDefault, (__bridge CFNetServiceRef) service, &readStream, &writeStream);
	
	if (!writeStream || !readStream) return nil;
	
	NSInputStream *input = (__bridge_transfer NSInputStream *) readStream;
	NSOutputStream *output = (__bridge_transfer NSOutputStream *) writeStream;
	
	return [self initWithInputStream:input outputStream:output userName:userName];
}

- (id)initWithInputStream:(NSInputStream *)input outputStream:(NSOutputStream *)output userName:(NSString *)userName;
{
	if (!(self = [super init])) return nil;
	
	inputStream = input;
	outputStream = output;
	
	inputStream.delegate = self;
	outputStream.delegate = self;
	
	[self sendLine:[@"VideoParty/1.0 " stringByAppendingString:userName]];
	
	return self;
}

- (void)sendLine:(NSString *)line;
{
	NSString *terminatedLine = [line stringByAppendingString:@"\n"];
	NSData *lineData = [terminatedLine dataUsingEncoding:NSUTF8StringEncoding];
	
	if (toSend.length == 0)
	{
		NSUInteger sent = 0;
		NSUInteger offset = 0;
		do
		{
			sent = [outputStream write:&(lineData.bytes[offset]) maxLength:lineData.length - offset];
			offset += sent;
		} while (offset < lineData.length && sent > 0);
		
		if (offset < lineData.length)
			[toSend appendBytes:&(lineData.bytes[offset]) length:lineData.length - offset];
	}
	else
		[toSend appendData:lineData];
}

- (void)parseReceivedData;
{
	NSData *terminatorData = [NSData dataWithBytes:"\n" length:1];
	
	NSUInteger bytesParsed = 0;
	
	while(true)
	{
		// Search only part not yet parsed
		NSRange searchRange = NSMakeRange(bytesParsed, receiveBuffer.length - bytesParsed);
		if (searchRange.length == 0) break;
		
		// Find the next \n
		NSRange terminatorRange = [receiveBuffer rangeOfData:terminatorData options:0 range:searchRange];
		if (terminatorRange.location == NSNotFound) break;
		
		// Extract the line. Note: Ignoring terminatorRange.length, because we don't want the \n
		// for the rest of the parsing.
		NSRange lineRange = NSMakeRange(bytesParsed, terminatorRange.location - bytesParsed);
		NSData *lineData = [receiveBuffer subdataWithRange:lineRange];
		NSString *line = [[NSString alloc] initWithData:lineData encoding:NSUTF8StringEncoding];
		
		// Parse
		[self parseLine:line];
		
		// Skip past the \n
		bytesParsed = NSMaxRange(terminatorRange);
	}
	
	if (bytesParsed < receiveBuffer.length)
	{
		receiveBuffer = [NSMutableData dataWithData:[receiveBuffer subdataWithRange:NSMakeRange(bytesParsed, receiveBuffer.length - bytesParsed)]];
	}
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent;
{
	if (streamEvent == NSStreamEventEndEncountered)
	{
		[inputStream close];
		[outputStream close];
		
		[self.delegate vpClientDisconnected:self];
	}
	else if (streamEvent == NSStreamEventErrorOccurred)
	{
		NSError *error = [theStream streamError];
		[inputStream close];
		[outputStream close];
		
		[self.delegate vpClient:self receivedError:error];
	}
	else if (theStream == inputStream && streamEvent == NSStreamEventHasBytesAvailable)
	{
		const NSUInteger bufferSize = 1024;
		uint8_t buffer[bufferSize];
		
		NSUInteger actuallyRead = 0;
		
		do
		{
			actuallyRead = [inputStream read:buffer maxLength:bufferSize];
			[receiveBuffer appendBytes:buffer length:actuallyRead];
		} while (actuallyRead > 0);
	}
	else if (theStream == outputStream && streamEvent == NSStreamEventHasSpaceAvailable)
	{
		if (toSend.length == 0) return;
		
		NSUInteger actuallySent = [outputStream write:toSend.bytes maxLength:toSend.length];
		toSend = [NSMutableData dataWithData:[toSend subdataWithRange:NSMakeRange(actuallySent, toSend.length - actuallySent)]];
	}
}

@end
