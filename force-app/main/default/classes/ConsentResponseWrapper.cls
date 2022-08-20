public class ConsentResponseWrapper {

    // wrapper class to retun multiple objects
    @AuraEnabled
    public List<Individual> indRecord { get; set;}
    @AuraEnabled
    public List<ContactPointEmail> cpe { get; set;}
    @AuraEnabled
    public List<ContactPointPhone> cpp { get; set;}

}
