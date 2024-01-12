import json
import boto3
     
# Bedrock Runtime client used to invoke and question the models
bedrock_runtime = boto3.client(
    service_name='bedrock-runtime', 
    region_name='us-east-1'
)

def lambda_handler(event, context):
    print(event)
    prompt = event.get("body")
     # The payload to be provided to Bedrock 
    body = json.dumps(
      {
          "prompt": "\n\nHuman:" + prompt + "\n\nAssistant:",
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

    response = bedrock_runtime.invoke_model(
       body=body, 
       modelId="anthropic.claude-v2:1", 
       accept='application/json', 
       contentType='application/json'
     )  
    response_body = json.loads(response.get('body').read())
    print(response_body)
     # The response from the model now mapped to the answer
    answer = response_body.get('completion')
     
    return {
       'statusCode': 200,
       'headers': {
         'Access-Control-Allow-Headers': '*',
         'Access-Control-Allow-Origin': '*',
         'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
       },
         'body': json.dumps({ "Answer": answer })
       }
