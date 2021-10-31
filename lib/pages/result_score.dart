import 'package:election_exit_poll_620710681/models/candidate2.dart';
import 'package:election_exit_poll_620710681/services/api.dart';
import 'package:flutter/material.dart';

class result_score extends StatefulWidget {
  const result_score({Key? key}) : super(key: key);

  @override
  _result_scoreState createState() => _result_scoreState();

  static const routeName = '/result_score';


}


class _result_scoreState extends State<result_score> {
  late Future<List<candidate2>> _futureCandidate;
  @override
  void initState() {
    super.initState();
    _futureCandidate = _fetch();
  }

  Future<List<candidate2>> _fetch() async {
    List list = await Api().fetch('exit_poll');
    var cd = list.map((e) => candidate2.fromJson(e)).toList();
    return cd;
  }

  Widget _buildCandidateCard(BuildContext context) {
    return FutureBuilder<List<candidate2>>(
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
                    //Text('${candidate.score}'),
                  ],
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
                Text('ผิดพลาด: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureCandidate = _fetch();
                    });
                  },
                  child: const Text('ลองใหม่'),
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
              Text("RESULT\n",style: TextStyle(fontSize: 30.0,color: Colors.white),),

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
                    Icons.assignment, // รูปไอคอน
                    size: 25.0, // ขนาดไอคอน
                    color: Colors.white, // สีไอคอน
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
