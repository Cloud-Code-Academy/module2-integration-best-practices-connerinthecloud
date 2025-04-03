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
            }
        } catch (CalloutException ex) {
            // bug statements are temporary and would/will be replaced by logging in prod env
            System.debug('there was an error during the callout.');
            System.debug('Exception message: ' + ex.getMessage());
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
        ExchangeRateWrapper erWrapper = new ExchangeRateWrapper();
        return erWrapper.toExchangeRates(rateData);
    }
    
    /**
     * @description Combines getting and processing rates into a single operation
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> updateExchangeRates() {
        ExchangeRateWrapper erWrapper = getLatestRates();
        System.debug('wrapper: ' + erWrapper);
        List<Exchange_Rate__c> exchngRates = processRates(erWrapper);
        System.debug('list: ' +exchngRates);
        try {
            upsert exchngRates External_Id__c;
        } catch (DmlException ex) {
            throw ex;
        }
        return exchngRates;
    }
}