const primaryColor = '#284B63';
const fontColor = '#7E7E7E';
const ctnColor = '#D4EFDF';
const selectedTabBarColor = '#64C0F0';
const counterColor = '#05172C';
const serverErrorMsg =
    'Oops... We hoped you would never get to see this page and we are working hard to make sure you never see it again.';
const noInternetExceptionMsg = 'In this case, it’s not us, it’s you 👀';
const noInternetExceptionMsgSubtext =
    'Please check your internet\nconnection and try again.';
String inventoryEndpoint(String storeId) =>
    'https://616e-2603-8001-b102-35ba-9aaa-1602-2f6e-d1ad.ngrok-free.app/api/stores/$storeId/products';
const String storeEndPoint =
    'https://616e-2603-8001-b102-35ba-9aaa-1602-2f6e-d1ad.ngrok-free.app/api/stores';
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
