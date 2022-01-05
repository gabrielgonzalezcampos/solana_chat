import 'dart:math';

import "package:solana/solana.dart";
import 'package:tuple/tuple.dart';

const SEED_LENGTH = 25;

String cluster = "https://api.devnet.solana.com";//"http://solana.test.node";//"http://127.0.0.1";//:8899";//"https://api.devnet.solana.com";
final connection = RPCClient(cluster);
late Wallet wallet;
late Account account;
var rng = Random.secure();


Future<Tuple2<RPCClient,Wallet>> initWallet() async{
  //print("Creating wallet...");

  Ed25519HDKeyPair keyPair = await Ed25519HDKeyPair.random();
  wallet = Wallet(signer: keyPair, rpcClient: connection);

  String transactionSignature = await wallet.requestAirdrop(lamports: await connection.getMinimumBalanceForRentExemption(300));
  TransactionResponse? confirmedTransaction = await connection.getConfirmedTransaction(transactionSignature);
  print("Wallet created");
  
  return Tuple2(connection, wallet);
}

Future<Tuple2<RPCClient,Wallet>> initWalletFromSeed(List<int> seed, {int size = 300}) async{
  // print("Creating wallet...");

  Ed25519HDKeyPair keyPair = await Ed25519HDKeyPair.fromSeedWithHdPath(seed: seed, hdPath: "m/44'/501'/0'/0'");
  wallet = Wallet(signer: keyPair, rpcClient: connection);

  String transactionSignature = await wallet.requestAirdrop(lamports: await connection.getMinimumBalanceForRentExemption(size));
  TransactionResponse? confirmedTransaction = await connection.getConfirmedTransaction(transactionSignature);
  // print("Wallet created");

  return Tuple2(connection, wallet);
}

//4rqzpkNu7LrFqntX45JTzjtTw35JUvwTb4TYNnE7BbA1

Future<String> sendMoney(String destPubkeyStr, int amount) async {

  // print("");
  // print("Send money transaction:");
  // print("From: ${wallet.address}");
  // print("To: ${destPubkeyStr}");
  // print("Sending money...");

  String transactionSignature = await wallet.transfer(destination: destPubkeyStr, lamports: amount);

  // print("Money sent!");
  return transactionSignature;
}


List<int> randomSeed(){
  List<List<int>> seedList = [];
  List<int> seed;
  seed = [];
  for(int i = 0; i < SEED_LENGTH; i++){
    seed.add(rng.nextInt(pow(2,16).toInt()));
  }
  print("SEED:");
  print(seed.toString());
  return seed;
}
