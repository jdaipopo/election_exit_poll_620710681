import 'package:election_exit_poll_620710681/models/candidate.dart';
import 'package:election_exit_poll_620710681/pages/result_score.dart';
import 'package:election_exit_poll_620710681/services/api.dart';
import 'package:flutter/material.dart';

class vote extends StatefulWidget {
  const vote({Key? key}) : super(key: key);

  static const routeName = '/vote';

  @override
  _voteState createState() => _voteState();
}

class _voteState extends State<vote> {

  late Future<List<candidate>> _futureCandidate;


  @override
  void initState() {
    super.initState();
    _futureCandidate = _fetch();
  }

  Future<List<candidate>> _fetch() async {
    List list = await Api().fetch('exit_poll');
    var cd = list.map((e) => candidate.fromJson(e)).toList();
    return cd;
  }

  Widget _buildCandidateCard(BuildContext context) {
    return FutureBuilder<List<candidate>>(
      future: _futureCandidate,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          var candidateList = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: candidateList!.length,
            itemBuilder: (BuildContext context, int index) {
              var candidate = candidateList[index];

              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(8.0),
                elevation: 5.0,
                shadowColor: Colors.black.withOpacity(0.2),
                color: Colors.white.withOpacity(0.5),
                child: InkWell(
                  onTap: () => _handleClickCandidate(candidate),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            '${candidate.number}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            '${candidate.title} ${candidate.firstName} ${candidate.lastName}',
                            style: Theme.of(context).textTheme.bodyText1
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('?????????????????????: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureCandidate = _fetch();
                    });
                  },
                  child: const Text('?????????????????????'),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [

              Image.asset("assets/images/vote_hand.png",height: 150.0,),
              Text("EXIT POLL\n",style: TextStyle(fontSize: 25.0,color: Colors.grey),),
              Text("??????????????????????????? ?????????.\n",style: TextStyle(fontSize: 30.0,color: Colors.white),),
              Text("?????????????????????????????????????????????????????????????????????????????????",style: TextStyle(fontSize: 16.0,color: Colors.white),),
              Text("??????????????????????????????????????????????????????????????????????????????????????????",style: TextStyle(fontSize: 16.0,color: Colors.white),),
              Text("??????????????????????????????????????????????????? ??????????????????????????????????????????",style: TextStyle(fontSize: 16.0,color: Colors.white),),

              _buildCandidateCard(context),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                      Navigator.pushNamed(
                        context, result_score.routeName
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(
                        horizontal: 70.0, vertical: 10.0),
                  ),
                  child: Icon(
                    Icons.assignment, // ????????????????????????
                    size: 25.0, // ???????????????????????????
                    color: Colors.white, // ?????????????????????
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _election(int candidateNumber) async {
    var elector = (await Api().submit('exit_poll', {'candidateNumber': candidateNumber}));
    _showMaterialDialog('SUCCESS', '?????????????????????????????????????????????????????? ${elector.toString()}');
  }

  _handleClickCandidate(candidate candidate) {
    _election(candidate.number);
  }
  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText1),
          actions: [
            // ???????????? OK ?????? dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ????????? dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
