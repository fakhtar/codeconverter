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
    print(event)