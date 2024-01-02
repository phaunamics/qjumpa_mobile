// import 'package:flutter/material.dart';
// import 'package:qjumpa/src/core/services/paystack_services.dart';
// import 'package:qjumpa/src/domain/entity/paystack_auth.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentScreen extends StatefulWidget {
//   static const routeName = '/paymentScreen';
//   // we need to get some info from customer and other like reference, amount, email
//   final String reference;
//   final String currency;
//   final String email;
//   final String amount;
//   final Object? metadata;
//   final Object? channel;
//   final Function(Object?)
//       onCompletedTransaction; // for notifying the user about the successful transaction
//   final Function(Object?)
//       onFailedTransaction; // For notifying user about the failed transaction

//   const PaymentScreen({
//     super.key,
//     required this.reference,
//     required this.currency,
//     required this.email,
//     required this.amount,
//     this.metadata,
//     this.channel,
//     required this.onCompletedTransaction,
//     required this.onFailedTransaction,
//   });

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // Next is to send the info to Paystack to initialize and generate authorized transction url so we need async widget like FutureBuilder
//     return FutureBuilder<PaystackAuthResponse>(
//         // when the paystaack send back the result, we need the model to get authorized url for the transaction
//         future: PaystackService().initializeTransaction(
//           email: widget.email,
//           amount: widget.amount,
//           reference: widget.reference,
//           metadata: widget.metadata,
//         ),
//         builder: (context, snapshot) {
//           // before we start to render the url, we need webview package and sometimes user may leave the web page after either abandoning or completing the transaction so we will use WillPopScope widget
//           return WillPopScope(
//             onWillPop: () async {
//               // we can use this way to verify if user has already completed or abandoned the web page
//               if (snapshot.connectionState == ConnectionState.done &&
//                   snapshot.hasData &&
//                   snapshot.data!.authorizationUrl != null) {
//                 PaystackService()
//                     .verifyTransaction(
//                       snapshot.data!.reference!,
//                       widget.onCompletedTransaction,
//                       widget.onFailedTransaction,
//                     )
//                     .then((value) => Navigator.of(context).pop());
//                 return false;
//               }
//               return true;
//             },
//             child: Scaffold(
//               appBar: AppBar(
//                 title: const Text("Paystack Payment "),
//                 leading: IconButton(
//                     onPressed: () {
//                       // User may want to leave the web page with or without completing the transaction
//                       // then we need to verify the transaction and notify the user of the transaction status
//                       // it is advisable to use webhook flow because according to Paystack, event of the transaction may take longer than expected.

//                       if (snapshot.connectionState == ConnectionState.done &&
//                           snapshot.hasData &&
//                           snapshot.data!.authorizationUrl != null) {
//                         PaystackService()
//                             .verifyTransaction(
//                               snapshot.data!.reference!,
//                               widget.onCompletedTransaction,
//                               widget.onFailedTransaction,
//                             )
//                             .then((value) => Navigator.of(context).pop());
//                       } else {
//                         Navigator.of(context).pop();
//                       }
//                     },
//                     icon: const Icon(Icons.close)),
//               ),
//               body: (snapshot.connectionState == ConnectionState.done &&
//                       snapshot.hasData &&
//                       snapshot.data!.authorizationUrl != null)
//                   ? WebView(
//                       initialUrl: snapshot.data!.authorizationUrl!,
//                       javascriptMode: JavascriptMode.unrestricted,
//                     )
//                   : snapshot.connectionState == ConnectionState.waiting
//                       ? const Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : Text("Here? : ${snapshot.error.toString()}"),
//             ),
//           );
//         });
//   }
// }
