//
//  VPClient.m
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import "VPClient.h"

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
	if (!(self = [super initWithInputStream:input outputStream:output])) return nil;
	
	[self sendLine:[@"VideoParty/1.0 " stringByAppendingString:userName]];
	
	return self;
}

- (void)parseLine:(NSString *)line;
{
	// Ignore empty lines
	if (line.length == 0) return;
	
	NSString *action = nil;
	
	NSScanner *scanner = [NSScanner scannerWithString:line];
	
	if (![scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&action]) return;
	
	if ([action isEqualToString:@"SetUsername"])
	{
		NSString *username;
		if (![scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&username]) return;
		
		[self.delegate vpClient:self changedUsernameTo:username];
	}
	else if ([action isEqualToString:@"SendPassword"])
	{
		[self.delegate vpClientRequestedPassword:self];
	}
	else if ([action isEqualToString:@"Tracklist"])
	{
		
	}
	else if ([action isEqualToString:@"Remove"])
	{
		
	}
	else if ([action isEqualToString:@"Add"])
	{
	
	}
	else if ([action isEqualToString:@"Play"])
	{
		
	}
	else if ([action isEqualToString:@"AddUser"])
	{
		
	}
	else if ([action isEqualToString:@"RemoveUser"])
	{
		
	}
}

- (void)disconnected;
{
	[self.delegate vpClientDisconnected:self];
}

- (void)receivedError:(NSError *)error;
{
	[self.delegate vpClient:self receivedError:error];
}


@end
