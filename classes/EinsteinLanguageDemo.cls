public with sharing class EinsteinLanguageDemo {
    public String selectedAPI {get; set;}
    public String customerFeedback {get; set;}
    public String rawOutput {get; set;}
    public EinsteinVision_PredictionResult predictionResult {get; set;}
        
    public List<SelectOption> apiOptions{
        get{
            if(apiOptions == null){
                apiOptions = new List<SelectOption>();
                apiOptions.add(new SelectOption('Sentiment', 'Sentiment'));
                apiOptions.add(new SelectOption('Intent', 'Intent'));
            }
            
            return apiOptions;
        }
        set;
    }
    
    public String endPoint {
        get{
            endPoint = 'https://api.einstein.ai/v2/language/sentiment';
            if(selectedAPI == 'Intent'){
                endPoint = 'https://api.einstein.ai/v2/language/intent';
            }
            
            return endPoint;
        }
        set;
    }
    
    public String modelId {
        get{
            if(selectedAPI == 'Sentiment'){
                modelId = 'CommunitySentiment';
            }
            
            return modelId;
        }
        set;
    }
    
    public EinsteinLanguageDemo (){
        selectedAPI = 'Sentiment';
    }
    
    public void submitToEinstein(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        
        request.setHeader('Authorization', 'Bearer ' + EinsteinVision_PredictionService.getAccessToken());
        request.setHeader('Cache-Control', 'no-cache');
        request.setMethod('POST');
        
        if(selectedAPI == 'Sentiment'){
            request.setHeader('Content-Type', 'application/json');
            String body = '{"modelId":"' + modelId + '","document":"' + customerFeedback + '"}';
            request.setBody(body);
        }else{
            String body = '';
            body += EinsteinVision_HttpBodyPart.WriteBoundary();
            body += EinsteinVision_HttpBodyPart.WriteBodyParameter('modelId', modelId);
            body += EinsteinVision_HttpBodyPart.WriteBoundary();
            body += EinsteinVision_HttpBodyPart.WriteBodyParameter('document', customerFeedback);            
            body += EinsteinVision_HttpBodyPart.WriteBoundary(EinsteinVision_HttpBodyPart.EndingType.CrLf);
            Blob bodyBlob = EncodingUtil.base64Decode(body);
            
            String contentLength = string.valueOf(bodyBlob.size());
            request.setHeader('Content-Type', EinsteinVision_HttpBodyPart.GetContentType());
            request.setHeader('Content-Length', contentLength);
            
            request.setBodyAsBlob(bodyBlob);
        }
        
        Http http = new Http();
        HTTPResponse response = http.send(request);
        
        rawOutput = response.getBody();
        
        predictionResult = (EinsteinVision_PredictionResult) JSON.deserialize(rawOutput, EinsteinVision_PredictionResult.class);
    }
    
}