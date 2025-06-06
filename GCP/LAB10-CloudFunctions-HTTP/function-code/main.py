import functions_framework
from flask import escape

@functions_framework.http
def hello_http(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response
    """
    # Get the name parameter from the request
    request_args = request.args
    name = request_args.get('name', 'World')
    
    # Return a response with the name parameter
    return f'Hello {escape(name)} from Cloud Functions!' 