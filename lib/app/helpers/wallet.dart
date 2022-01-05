import 'dart:math';

import "package:solana/solana.dart";
import 'package:tuple/tuple.dart';

const SEED_LENGTH = 25;

String cluster = "https://api.devnet.solana.com";//"http://solana.test.node";//"http://127.0.0.1";//:8899";//"https://api.devnet.solana.com";
final connection = SolanaClient(rpcUrl: Uri.parse(cluster), websocketUrl: Uri.parse("ws://api.devnet.solana.com"));
late Wallet wallet;
late Account account;
var rng = Random.secure();


Future<Tuple2<SolanaClient,Wallet>> initWallet() async{
  //print("Creating wallet...");

  Ed25519HDKeyPair keyPair = await Ed25519HDKeyPair.random();
  wallet = keyPair;

  String transactionSignature = await connection.requestAirdrop(lamports: await connection.rpcClient.getMinimumBalanceForRentExemption(300), address: wallet.address);
  TransactionDetails? confirmedTransaction = await connection.rpcClient.getTransaction(transactionSignature);
  print("Wallet created");
  
  return Tuple2(connection, wallet);
}

Future<Tuple2<SolanaClient,Wallet>> initWalletFromSeed(List<int> seed, {int size = 300}) async{
  // print("Creating wallet...");

  Ed25519HDKeyPair keyPair = await Ed25519HDKeyPair.fromSeedWithHdPath(seed: seed, hdPath: "m/44'/501'/0'/0'");
  wallet = keyPair;

  String transactionSignature = await connection.requestAirdrop(lamports: 10245120/*await connection.rpcClient.getMinimumBalanceForRentExemption(size)*/, address: wallet.address);
  TransactionDetails? confirmedTransaction = await connection.rpcClient.getTransaction(transactionSignature);
  // print("Wallet created");

  return Tuple2(connection, wallet);
}

//4rqzpkNu7LrFqntX45JTzjtTw35JUvwTb4TYNnE7BbA1


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
