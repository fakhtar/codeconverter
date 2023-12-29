import json
import boto3
    
    # Bedrock client used to interact with APIs around models
bedrock = boto3.client(
    service_name='bedrock', 
    region_name='us-east-1'
)
     
    # Bedrock Runtime client used to invoke and question the models
bedrock_runtime = boto3.client(
    service_name='bedrock-runtime', 
    region_name='us-east-1'
)

def handler(event, context):
     # Just shows an example of how to retrieve information about available models
    #  foundation_models = bedrock.list_foundation_models()
    #  matching_model = next((model for model in foundation_models["modelSummaries"] if model.get("modelName") == "Jurassic-2 Ultra"), None)
    
    #  prompt = json.loads(event.get("body")).get("input").get("question")
    
     # The payload to be provided to Bedrock 
     body = json.dumps(
       {
          "prompt": "Why is pluto no longer a planet", 
          "maxTokens": 200,
          "temperature": 0.7,
          "topP": 1,
       }
     )
     
     # The actual call to retrieve an answer from the model
     response = bedrock_runtime.invoke_model(
       body=body, 
       modelId="anthropic.claude-v2:1", 
       accept='application/json', 
       contentType='application/json'
     )
    
     response_body = json.loads(response.get('body').read())
    
     # The response from the model now mapped to the answer
     answer = response_body.get('completions')[0].get('data').get('text')
     
     return {
       'statusCode': 200,
       'headers': {
         'Access-Control-Allow-Headers': '*',
         'Access-Control-Allow-Origin': '*',
         'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
       },
         'body': json.dumps({ "Answer": answer })
       }

# import os
# import os.path
# import sys
 
# envLambdaTaskRoot = os.environ["LAMBDA_TASK_ROOT"]
# print("LAMBDA_TASK_ROOT env var:"+os.environ["LAMBDA_TASK_ROOT"])
# print("sys.path:"+str(sys.path))
 
# sys.path.insert(0,envLambdaTaskRoot+"/NewBotoVersion")
# print("sys.path:"+str(sys.path))
# import botocore
# import boto3
 
# print("boto3 version:"+boto3.__version__)
# print("botocore version:"+botocore.__version__)

 
# def lambda_handler(event,context):
#     b = 'Why is Pluto no longer a planet?'.encode('utf-8')
#     client = boto3.client('bedrock-runtime')
#     response = client.invoke_model(
#     body=b,
#     modelId='anthropic.claude-v2:1'
#     )
#     print(event)