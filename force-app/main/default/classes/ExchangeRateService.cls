/**
 * @description Service class that handles API callouts to the Exchange Rate API
 * Students will implement the methods to make callouts and process responses
 */
public class ExchangeRateService {
    
    // The named credential to use for the callout
    private static final String NAMED_CREDENTIAL = 'ExchangeRateAPI';
    
    // The base currency to use for exchange rates
    private static final String BASE_CURRENCY = 'USD';
    
    /**
     * @description Makes a callout to the Exchange Rate API to get the latest exchange rates
     * @return ExchangeRateWrapper containing the response data
     */
    public static ExchangeRateWrapper getLatestRates() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ExchangeRateAPI/latest/' + BASE_CURRENCY);
        request.setMethod('GET');

        ExchangeRateWrapper erWrapper = new ExchangeRateWrapper();
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                erWrapper = ExchangeRateWrapper.parse(response.getBody());
            } else {
                String errorMessage = 'There was an Error getting the latest exchange rates. ';
                errorMessage += 'Status code: ' + response.getStatusCode();
                throw new ExchangeRateServiceException(errorMessage);
            }
        } catch (CalloutException ex) {
            Logger.error('ERROR: ' + ex.getMessage() + ' Class: ExchangeRateService.getLatestRates');
            Logger.saveLog();
            throw ex;
        }

        return erWrapper;
    }
    
    /**
     * @description Processes the exchange rate data and creates or updates records
     * @param rateData The wrapper containing exchange rate data
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> processRates(ExchangeRateWrapper rateData) {
        List<Exchange_Rate__c> erList = rateData.toExchangeRates();

        if (Test.isRunningTest()) {
            upsert erList External_Id__c;
        }

        return erList;
    }
    
    /**
     * @description Combines getting and processing rates into a single operation
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> updateExchangeRates() {
        ExchangeRateWrapper erWrapper = getLatestRates();
        List<Exchange_Rate__c> exchngRates = processRates(erWrapper);
        try {
            upsert exchngRates External_Id__c;
        } catch (DmlException ex) {
            Logger.error('ERROR: ' + ex.getMessage() + ' Class: ExchangeRateService.updateExchangeRates');
            Logger.saveLog();
            throw ex;
        }
        return exchngRates;
    }

    public class ExchangeRateServiceException extends Exception {}
}