import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trilhas_phb/models/hike.dart';

class HikeService {
  final _collection = FirebaseFirestore.instance.collection('trilhas');

  Future<List<HikeModel>> getHikes() async {
    try {
      QuerySnapshot querySnapshot = await _collection.get();
      final data = querySnapshot.docs.map(
        (doc) => HikeModel.fromMap(doc.data() as Map<String, dynamic>)
      ).toList();
      return data;
    } catch (e) {
      print(e.toString());
      return List.empty();
    }
  }
}

/*StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('trilhas').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(height: 150, child: Center(child: CircularProgressIndicator()));
              }
      
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Sem dados'));
              }
      
              return Container(
                height: 150,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var data = doc.data() as Map<String, dynamic>;
                
                    return Container(
                      width: 100,
                      child: Column(children: [
                        Text(data['nome']),
                        Text(data['descricao'])
                      ],),
                    );
                  },
                ),
              );
            },
          ) */