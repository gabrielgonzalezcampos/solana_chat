import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:solana/solana.dart';
import 'package:solana_chat/config/config.dart';

const programID = addMessageProgramID;

Future<String> getChatMessageAccountPubKey(
    SolanaClient connection,
    Wallet wallet,
    int space,
    {bool reset = false}
    ) async {
  if (!reset) {
    //wallet.
  }
  Ed25519HDKeyPair keyPair = await Ed25519HDKeyPair.random();
  int rent = await connection.rpcClient.getMinimumBalanceForRentExemption(space);

  Instruction instruction = SystemInstruction.createAccount(
    fromPubKey:  wallet.address,
    owner: programID,
    pubKey: keyPair.address,
    lamports: rent,
    space: space,
  );

  Message message = Message(instructions: [instruction]);

  String signature = await connection.rpcClient.signAndSendTransaction(message, [wallet, keyPair]);

  await connection.waitForSignatureStatus(signature, status: ConfirmationStatus.finalized);

  print("Account: ${keyPair.address}");
  return keyPair.address;
}