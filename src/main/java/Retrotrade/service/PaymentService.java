package Retrotrade.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import net.authorize.Environment;
import net.authorize.api.contract.v1.*;
import net.authorize.api.controller.CreateTransactionController;
import net.authorize.api.controller.base.ApiOperationBase;

@Service
public class PaymentService {

    private static final Logger log = LoggerFactory.getLogger(PaymentService.class);

    // Authorize.net Sandbox Credentials (provided)
    private static final String API_LOGIN_ID = "6C7jpQ322";
    private static final String TRANSACTION_KEY = "99U2Zs2mz2UVb4ee";

    /**
     * Processes a credit card payment through Authorize.net.
     *
     * @param email        Buyer's email
     * @param cardNumber   Credit card number (e.g., "4111111111111111")
     * @param expiryDate   Expiration date in format "YYYY-MM" (e.g., "2026-12")
     * @param cvv          Card CVV code
     * @param amount       Payment amount in Rupees (or any currency)
     * @return PaymentResult object containing success flag, transaction ID, and error message
     */
    public PaymentResult processCreditCardPayment(String email, String cardNumber,
                                                  String expiryDate, String cvv,
                                                  BigDecimal amount) {
        PaymentResult result = new PaymentResult();

        try {
            // Set environment to sandbox
            ApiOperationBase.setEnvironment(Environment.SANDBOX);

            // Merchant authentication
            MerchantAuthenticationType merchantAuth = new MerchantAuthenticationType();
            merchantAuth.setName(API_LOGIN_ID);
            merchantAuth.setTransactionKey(TRANSACTION_KEY);

            // Credit card details
            CreditCardType creditCard = new CreditCardType();
            creditCard.setCardNumber(cardNumber);
            // Authorize.net expects "YYYY-MM" format
            creditCard.setExpirationDate(expiryDate);
            creditCard.setCardCode(cvv);

            PaymentType paymentType = new PaymentType();
            paymentType.setCreditCard(creditCard);

            // Customer info (optional)
            CustomerDataType customer = new CustomerDataType();
            customer.setEmail(email);

            // Transaction request
            TransactionRequestType txnRequest = new TransactionRequestType();
            txnRequest.setTransactionType(TransactionTypeEnum.AUTH_CAPTURE_TRANSACTION.value());
            txnRequest.setPayment(paymentType);
            txnRequest.setCustomer(customer);
            txnRequest.setAmount(amount.setScale(2, RoundingMode.HALF_UP));

            // Create request
            CreateTransactionRequest apiRequest = new CreateTransactionRequest();
            apiRequest.setMerchantAuthentication(merchantAuth);
            apiRequest.setTransactionRequest(txnRequest);

            // Execute
            CreateTransactionController controller = new CreateTransactionController(apiRequest);
            controller.execute();

            CreateTransactionResponse response = controller.getApiResponse();

            if (response != null) {
                if (response.getMessages().getResultCode() == MessageTypeEnum.OK) {
                    TransactionResponse txnResponse = response.getTransactionResponse();
                    if (txnResponse.getMessages() != null) {
                        String transId = txnResponse.getTransId();
                        log.info("Payment successful. Transaction ID: {}", transId);
                        result.setSuccess(true);
                        result.setTransactionId(transId);
                        result.setAuthCode(txnResponse.getAuthCode());
                        return result;
                    } else {
                        // Transaction failed (e.g., declined)
                        String errorText = "Payment declined";
                        if (txnResponse.getErrors() != null && !txnResponse.getErrors().getError().isEmpty()) {
                            errorText = txnResponse.getErrors().getError().get(0).getErrorText();
                        }
                        log.error("Payment failed: {}", errorText);
                        result.setSuccess(false);
                        result.setErrorMessage(errorText);
                        return result;
                    }
                } else {
                    // API-level error
                    String errorMsg = response.getMessages().getMessage().get(0).getText();
                    log.error("Authorize.net API error: {}", errorMsg);
                    result.setSuccess(false);
                    result.setErrorMessage(errorMsg);
                    return result;
                }
            } else {
                // No response (network error, etc.)
                String errorMsg = "No response from payment gateway";
                log.error(errorMsg);
                result.setSuccess(false);
                result.setErrorMessage(errorMsg);
                return result;
            }
        } catch (Exception e) {
            log.error("Exception during payment processing", e);
            result.setSuccess(false);
            result.setErrorMessage("Payment processing error: " + e.getMessage());
            return result;
        }
    }

    /**
     * Inner class to hold payment result.
     */
    public static class PaymentResult {
        private boolean success;
        private String transactionId;
        private String authCode;
        private String errorMessage;

        // Getters and setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        public String getTransactionId() { return transactionId; }
        public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
        public String getAuthCode() { return authCode; }
        public void setAuthCode(String authCode) { this.authCode = authCode; }
        public String getErrorMessage() { return errorMessage; }
        public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    }
}