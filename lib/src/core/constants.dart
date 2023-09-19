const primaryColor = '#284B63';
const fontColor = '#7E7E7E';
const ctnColor = '#D4EFDF';
const selectedTabBarColor = '#64C0F0';
const counterColor = '#05172C';
String inventoryEndpoint(String storeId) =>
    'https://62f0-2603-8001-b102-35ba-8494-d05d-a15c-a221.ngrok-free.app/api/users/$storeId/products';
const String storeEndPoint =
    'https://62f0-2603-8001-b102-35ba-8494-d05d-a15c-a221.ngrok-free.app/api/users';
const String initialTransactionUrl =
    'https://api.paystack.co/transaction/initialize';
String verifyTransactionUrl(String reference) =>
    'https://api.paystack.co/transaction/verify/$reference';
const listTransactionUrl = 'https://api.paystack.co/transaction';
const String createCustomer = 'https://api.paystack.co/customer';
const String listCustomers = 'https://api.paystack.co/customer';
String fetchCustomer(String emailOrCode) =>
    'https://api.paystack.co/customer/$emailOrCode';
String updateCustomer(String emailOrCode) =>
    'https://api.paystack.co/customer/$emailOrCode';
