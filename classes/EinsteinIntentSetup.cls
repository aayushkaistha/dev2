public with sharing class EinsteinIntentSetup extends EinsteinVision_HttpBodyPart {
    public String fileUrl {get; set;}
    public String datasetId {get; set;}
    public String modelId {get; set;}
    public String uploadStatus {get; set;}
    public String rawOutput {get; set;}
    
    public void uploadFile(){
        try{
            if(fileUrl == null || fileUrl == ''){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'File URL not provided!'));
            }
            
            String body = '';
            body += WriteBoundary();
            body += WriteBodyParameter('path', fileUrl);
            body += WriteBoundary();
            body += WriteBodyParameter('type', 'text-intent');            
            body += WriteBoundary(EndingType.CrLf);
            Blob bodyBlob = EncodingUtil.base64Decode(body);
            String contentLength = string.valueOf(bodyBlob.size());
            
            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', 'Bearer ' + EinsteinVision_PredictionService.getAccessToken());
            request.setHeader('Cache-Control', 'no-cache');
            request.setHeader('Content-Type', EinsteinVision_HttpBodyPart.GetContentType());
            request.setHeader('Content-Length', contentLength);
            
            request.setEndpoint('https://api.einstein.ai/v2/language/datasets/upload');
            request.setMethod('POST');
            
            request.setBodyAsBlob(bodyBlob);
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            
            rawOutput = response.getBody();
            
            //resp is a JSON string
            JSONParser parser = JSON.createParser(rawOutput);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'id') {
                        datasetId = parser.getText();
                    } else if(fieldName == 'statusMsg' || fieldName == 'message'){
                        uploadStatus = parser.getText();
                    }
                }
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
    
    public void checkUploadStatus(){
        try{
            if(datasetId == null || datasetId == ''){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Dataset Id not provided!'));
            }
            
            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', 'Bearer ' + EinsteinVision_PredictionService.getAccessToken());
            request.setHeader('Cache-Control', 'no-cache');
            
            request.setEndpoint('https://api.einstein.ai/v2/language/datasets/' + datasetId);
            request.setMethod('GET');
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            
            rawOutput = response.getBody();
            
            //resp is a JSON string
            JSONParser parser = JSON.createParser(rawOutput);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'statusMsg' || fieldName == 'message'){
                        uploadStatus = parser.getText();
                    }
                }
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
    
    public void trainDataSet(){
        try{
            if(datasetId == null || datasetId == ''){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Dataset Id not provided!'));
            }
            
            String body = '';
            body += WriteBoundary();
            body += WriteBodyParameter('name', 'Case Routing Model');
            body += WriteBoundary();
            body += WriteBodyParameter('datasetId', datasetId);            
            body += WriteBoundary(EndingType.CrLf);
            Blob bodyBlob = EncodingUtil.base64Decode(body);
            String contentLength = string.valueOf(bodyBlob.size());
            
            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', 'Bearer ' + EinsteinVision_PredictionService.getAccessToken());
            request.setHeader('Cache-Control', 'no-cache');
            request.setHeader('Content-Type', EinsteinVision_HttpBodyPart.GetContentType());
            request.setHeader('Content-Length', contentLength);
            
            request.setEndpoint('https://api.einstein.ai/v2/language/train');
            request.setMethod('POST');
            
            request.setBodyAsBlob(bodyBlob);
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            
            rawOutput = response.getBody();
            
            //resp is a JSON string
            JSONParser parser = JSON.createParser(rawOutput);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'modelId') {
                        modelId = parser.getText();
                    } else if(fieldName == 'status' || fieldName == 'message'){
                        uploadStatus = parser.getText();
                    }
                }
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
    
    public void checkTrainingStatus(){
        try{
            if(modelId == null || modelId == ''){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Model Id not provided!'));
            }
            
            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', 'Bearer ' + EinsteinVision_PredictionService.getAccessToken());
            request.setHeader('Cache-Control', 'no-cache');
            
            request.setEndpoint('https://api.einstein.ai/v2/language/train/' + modelId);
            request.setMethod('GET');
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            
            rawOutput = response.getBody();
            
            //resp is a JSON string
            JSONParser parser = JSON.createParser(rawOutput);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'status' || fieldName == 'message'){
                        uploadStatus = parser.getText();
                    }
                }
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
}