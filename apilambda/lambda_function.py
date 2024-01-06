import json
import boto3
     
# Bedrock Runtime client used to invoke and question the models
bedrock_runtime = boto3.client(
    service_name='bedrock-runtime', 
    region_name='us-east-1'
)

def lambda_handler(event, context):

    prompt = event.get("body")
     # The payload to be provided to Bedrock 
    body = json.dumps(
      {
          "prompt": prompt,
          "max_tokens_to_sample": 300,
          "temperature": 0.5,
          "top_k": 250,
          "top_p": 1,
          "stop_sequences": [
            "\n\nHuman:"
          ],
          "anthropic_version": "bedrock-2023-05-31"
        }
     )
     
     # The actual call to retrieve an answer from the model
    # response = bedrock_runtime.invoke_model(
    #    body=body, 
    #    modelId="ai21.j2-ultra-v1", 
    #    accept='application/json', 
    #    contentType='application/json'
    #  )

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