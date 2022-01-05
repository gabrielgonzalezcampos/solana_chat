import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/config/config.dart';

const programID = addMessageProgramID;

Future<String> getChatMessageAccountPubKey(
    RPCClient connection,
    Wallet wallet,
    int space,
    {bool reset = false}
    ) async {
  if (!reset) {
    //wallet.
  }
  Ed25519HDKeyPair keyPair = await Ed25519HDKeyPair.random();
  int rent = await connection.getMinimumBalanceForRentExemption(space);

  Instruction instruction = SystemInstruction.createAccount(
    address: keyPair.address,
    owner: wallet.address,
    rent: rent,
    space: space,
    programId: programID,
  );

  Message message = Message(instructions: [instruction]);

  String signature = await connection.signAndSendTransaction(message, [wallet.signer, keyPair]);

  await connection.waitForSignatureStatus(signature, Commitment.finalized);

  print("Account: ${keyPair.address}");
  return keyPair.address;
}