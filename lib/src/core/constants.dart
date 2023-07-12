const primaryColor = '#0F2F2E';
const fontColor = '#7E7E7E';
const ctnColor = '#D4EFDF';
const selectedColor = '#58FFFA';
const counterColor = '#05172C';
const String inventoryEndpoint =
    'https://qjumpa-production.up.railway.app/api/products';
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
