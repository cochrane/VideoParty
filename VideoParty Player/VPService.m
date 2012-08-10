//
//  VPService.m
//  VideoParty
//
//  Created by Torsten Kammer on 10.08.12.
//
//

#import "VPService.h"

#include <netinet/in.h>

#import "VPServiceConstants.h"

@interface VPService ()

@property (retain, nonatomic) NSFileHandle *handle;
@property (retain, nonatomic) NSSocketPort *port;
@property (retain, nonatomic) NSNetService *service;
@property (retain, nonatomic) NSOperationQueue *acceptConnectionQueue;
@property (retain, nonatomic) NSOperationQueue *dataReceivedQueue;

- (void)acceptNewConnection:(NSNotification *)notification;

@end

@implementation VPService

- (id)initWithName:(NSString *)name;
{
	if (!(self = [super init])) return nil;
	
	self.port = [[NSSocketPort alloc] initWithTCPPort:0];
	uint16_t portNumber = 0;
	
	// Get port number
	if (self.port.protocolFamily == AF_INET6)
	{
		const struct sockaddr_in6 *address = (struct sockaddr_in6 *) [self.port.address bytes];
		assert(address != NULL);
		
		portNumber = address->sin6_port;
	}
	else if (self.port.protocolFamily == AF_INET)
	{
		const struct sockaddr_in *address = (struct sockaddr_in *) [self.port.address bytes];
		assert(address != NULL);
		
		portNumber = address->sin_port;
	}
	
	NSLog(@"Started service on port %u", portNumber);
	
	self.handle = [[NSFileHandle alloc] initWithFileDescriptor:self.port.socket];
	[self.handle acceptConnectionInBackgroundAndNotify];
	
	self.acceptConnectionQueue = [[NSOperationQueue alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleConnectionAcceptedNotification object:self.handle queue:self.acceptConnectionQueue usingBlock:^(NSNotification *notification) {
		[self acceptNewConnection:notification];
	}];
	
	self.service = [[NSNetService alloc] initWithDomain:VPDefaultDomain type:VPServiceName name:name port:portNumber];
	
	return self;
}

- (void)acceptNewConnection:(NSNotification *)notification;
{
	
}

@end
