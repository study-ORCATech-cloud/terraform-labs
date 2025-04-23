"""
Lambda function handler for the LAB10 serverless API

This function demonstrates handling of different HTTP methods:
- GET: Return a hello message with query parameters
- POST: Process JSON payload and return a confirmation
- PUT: Update a resource (simulated)
- DELETE: Remove a resource (simulated)
"""

import json
import os
import time
from datetime import datetime

def handler(event, context):
    log_level = os.environ.get('LOG_LEVEL', 'info')
    
    if log_level in ['debug', 'info']:
        print(f"Event: {json.dumps(event, indent=2)}")
    
    try:
        # Get the HTTP method and path
        http_method = event.get('httpMethod') or event.get('requestContext', {}).get('http', {}).get('method')
        path = event.get('path') or event.get('requestContext', {}).get('http', {}).get('path')
        
        # Parse query parameters
        query_params = event.get('queryStringParameters') or {}
        
        # Parse request body if present
        body = {}
        if event.get('body'):
            try:
                body = json.loads(event['body'])
            except Exception as e:
                print(f"Error parsing body: {e}")
        
        # Simple router based on method and path
        if http_method == 'GET':
            if path == '/hello':
                name = query_params.get('name', 'World')
                return {
                    'statusCode': 200,
                    'headers': {
                        'Content-Type': 'application/json',
                        'Access-Control-Allow-Origin': '*'
                    },
                    'body': json.dumps({
                        'message': f"Hello, {name}!",
                        'environment': os.environ.get('environment', 'unknown'),
                        'timestamp': datetime.now().isoformat()
                    })
                }
            elif path == '/info':
                return {
                    'statusCode': 200,
                    'headers': {
                        'Content-Type': 'application/json',
                        'Access-Control-Allow-Origin': '*'
                    },
                    'body': json.dumps({
                        'service': 'Lambda API Demo',
                        'version': '1.0.0',
                        'environment': os.environ.get('environment', 'unknown'),
                        'region': os.environ.get('AWS_REGION', 'unknown'),
                        'logLevel': os.environ.get('LOG_LEVEL', 'info')
                    })
                }
        elif http_method == 'POST' and path == '/items':
            # Simulate creating a new item
            if not body.get('name'):
                return {
                    'statusCode': 400,
                    'headers': {
                        'Content-Type': 'application/json',
                        'Access-Control-Allow-Origin': '*'
                    },
                    'body': json.dumps({
                        'message': 'Missing required field: name'
                    })
                }
            
            if log_level == 'debug':
                print(f"Creating item with name: {body.get('name')}")
            
            return {
                'statusCode': 201,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'message': 'Item created successfully',
                    'item': {
                        'id': f"item-{int(time.time() * 1000)}",
                        'name': body.get('name'),
                        'createdAt': datetime.now().isoformat()
                    }
                })
            }
        elif http_method == 'PUT' and path.startswith('/items/'):
            # Simulate updating an item
            item_id = path.split('/')[-1]
            
            if log_level == 'debug':
                print(f"Updating item with ID: {item_id}, Data: {json.dumps(body)}")
            
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'message': f"Item {item_id} updated successfully",
                    'item': {
                        'id': item_id,
                        **body,
                        'updatedAt': datetime.now().isoformat()
                    }
                })
            }
        elif http_method == 'DELETE' and path.startswith('/items/'):
            # Simulate deleting an item
            item_id = path.split('/')[-1]
            
            if log_level == 'debug':
                print(f"Deleting item with ID: {item_id}")
            
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'message': f"Item {item_id} deleted successfully"
                })
            }
        elif http_method == 'OPTIONS':
            # Handle CORS preflight requests
            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type,Authorization',
                    'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS'
                },
                'body': ''
            }
        
        # Default response for other routes
        if log_level in ['debug', 'info']:
            print(f"Route not found: {http_method} {path}")
        
        return {
            'statusCode': 404,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'Route not found',
                'path': path,
                'method': http_method
            })
        }
    except Exception as error:
        print(f"Error: {error}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'Internal Server Error',
                'error': str(error)
            })
        } 