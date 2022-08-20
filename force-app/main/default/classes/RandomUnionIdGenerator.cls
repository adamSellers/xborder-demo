public with sharing class RandomUnionIdGenerator {
    public static String generateUnionId() {
        // generate two separate strings to concatenate into union id
        // of syntax o6_bmasdasdsad6_2sgVt7hMZOPfL
        final String chars = 'xaxPmno2IDdEwLzbtEvhv6oG1RDT6xQJX3MvF4amaDQ9TUvHgJfdbodlllPTnnuw';
        String strPrefix = 'o6_';

        String strOne = '';
        while(strOne.length() < 13) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            strOne += chars.substring(idx, idx+1);
        }

        String strTwo = '';
        while(strTwo.length() < 14) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            strTwo += chars.substring(idx, idx+1);
        }

        // build the final string
        String toReturn = strPrefix + strOne + '_' + strTwo;

        return toReturn;
    }
}
