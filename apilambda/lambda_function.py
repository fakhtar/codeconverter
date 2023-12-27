import os
import os.path
import sys
 
envLambdaTaskRoot = os.environ["LAMBDA_TASK_ROOT"]
print("LAMBDA_TASK_ROOT env var:"+os.environ["LAMBDA_TASK_ROOT"])
print("sys.path:"+str(sys.path))
 
sys.path.insert(0,envLambdaTaskRoot+"/NewBotoVersion")
print("sys.path:"+str(sys.path))
import botocore
import boto3
 
print("boto3 version:"+boto3.__version__)
print("botocore version:"+botocore.__version__)

 
def lambda_handler(event,context):
    b = 'Why is Pluto no longer a planet?'.encode('utf-8')
    client = boto3.client('bedrock-runtime')
    response = client.invoke_model(
    body=b,
    modelId='anthropic.claude-v2:1'
    )
    print(response.body)
