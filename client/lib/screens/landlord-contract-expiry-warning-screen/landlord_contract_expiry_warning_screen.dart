import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/landlord-contract-expiry-warning-screen/components/body.dart';
import 'package:flutter/material.dart';

/// Contract Expiry Warning Screen for Landlords
///
/// This screen displays a warning when a rental contract is approaching its expiration date.
/// It provides the landlord with the following options:
/// - Extend the contract for continued rental
/// - Update contract details
/// - End the contract and return the room
/// - Set a reminder to be notified again in 3 days
///
/// The screen shows:
/// - A visual warning indicator
/// - Contract details (room number and expiry date)
/// - Countdown timer showing days remaining
/// - Action buttons for managing the contract
class LandlordContractExpiryWarningScreen extends StatelessWidget {
  // TODO: Add contract parameter when contract model is available
  // final Contract contract;

  const LandlordContractExpiryWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: "Cảnh báo hết hạn"),
      body: Body(),
    );
  }
}
