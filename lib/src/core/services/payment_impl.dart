// Step 1: Set up your Paystack account
// - Sign up for a Paystack account at https://dashboard.paystack.com/#/signup.
// - Get your API keys from the Paystack Dashboard. You'll need the secret key for server-side transactions and the public key for client-side transactions.


// void initState() {
//   super.initState();
//   PaystackPlugin.initialize(publicKey: 'YOUR_PUBLIC_KEY');
// }

// void startPayment() async {
//   Charge charge = Charge()
//     ..amount = 10000 // Amount in kobo
//     ..email = 'customer@example.com'
//     ..reference = 'YOUR_REFERENCE'; // Unique transaction reference

//   try {
//     CheckoutResponse response =
//         await PaystackPlugin.chargeCard(context, charge);
//     if (response.status == true) {
//       // Payment was successful
//       // Handle success response
//     } else {
//       // Payment failed
//       // Handle failure response
//     }
//   } on PlatformException catch (error) {
//     // Handle platform exceptions (e.g., invalid charge parameters, invalid card details)
//     print('Payment failed: ${error.message}');
//   } catch (error) {
//     // Handle other exceptions
//     print('Payment failed: $error');
//   }
// }
