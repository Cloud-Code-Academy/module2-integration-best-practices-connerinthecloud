/**
 * @description Wrapper class to deserialize the JSON response from the Exchange Rate API
 * Students will implement the properties and methods to process the data
 */
public class ExchangeRateWrapper {
    // Add properties for base currency
    public String base_code;    
    // Add property for time last updated
    public Integer time_last_update_unix;
    
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
        // 1. Create a list to hold the Exchange_Rate__c records
        // 2. Iterate through the rates map
        // 3. For each rate, create an Exchange_Rate__c record
        // 4. Return the list of records
        List<Exchange_Rate__c> exchngRateList = new List<Exchange_Rate__c>();
        for (String isoCurrencyCode : conversion_rates.keySet()) {
            Exchange_Rate__c exchngRate = new Exchange_Rate__c();
            exchngRate.Name = base_code + '-->' + isoCurrencyCode;
            exchngRate.Base_Currency__c = base_code;
            exchngRate.Target_Currency__c = isoCurrencyCode;
            exchngRate.Last_Updated__c = Datetime.newInstance(time_last_update_unix);
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
        // TODO: Implement the method to parse the JSON response
        // Use JSON.deserialize or JSON.deserializeStrict to parse the response
        ExchangeRateWrapper exchRateWrapper = (ExchangeRateWrapper) JSON.deserialize(jsonResponse, ExchangeRateWrapper.class);

        return exchRateWrapper; // Replace with actual implementation
    }
}