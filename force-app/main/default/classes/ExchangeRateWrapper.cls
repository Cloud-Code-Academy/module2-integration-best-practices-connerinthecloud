/**
 * @description Wrapper class to deserialize the JSON response from the Exchange Rate API
 * Students will implement the properties and methods to process the data
 */
public class ExchangeRateWrapper {
    // Add properties for base currency
    public String base_code;    
    // Add property for time last updated
    public String time_last_update_unix;
    
    // Add property for rates (using a map)
    public Map<String, Decimal> conversion_rates;

    // Add property for external ID
    // This is an ID you will generate to uniquely identify the exchange rate record
    // This does not come from the API response
    public String externalId; // baseCurrency + '_' + targetCurrency;


    // Added properties for error handling
    public String result;
    public String errortype;
    
    /**
     * @description Converts the wrapper data to a list of Exchange_Rate__c records
     * @return List<Exchange_Rate__c> The list of exchange rate records
     */
    public List<Exchange_Rate__c> toExchangeRates() {
        DateTime unixTimeMiliseconds = DateTime.newInstance(Long.valueof(time_last_update_unix)*1000);
        List<Exchange_Rate__c> exchngRateList = new List<Exchange_Rate__c>();

        for (String isoCurrencyCode : conversion_rates.keySet()) {
            Exchange_Rate__c exchngRate = new Exchange_Rate__c();
            exchngRate.Name = base_code + '_' + isoCurrencyCode;
            exchngRate.Base_Currency__c = base_code;
            exchngRate.Target_Currency__c = isoCurrencyCode;
            exchngRate.Last_Updated__c = unixTimeMiliseconds;
            exchngRate.Rate__c = conversion_rates.get(isoCurrencyCode);
            exchngRate.External_Id__c = base_code + isoCurrencyCode;
            exchngRateList.add(exchngRate);
        }
        
        return exchngRateList;
    }
    
    /**
     * @description Static method to parse the JSON response into the wrapper class
     * @param jsonResponse The JSON response from the API
     * @return ExchangeRateWrapper The parsed wrapper instance
     */
    public static ExchangeRateWrapper parse(String jsonResponse) {

        return (ExchangeRateWrapper) JSON.deserialize(jsonResponse, ExchangeRateWrapper.class);
    }
}