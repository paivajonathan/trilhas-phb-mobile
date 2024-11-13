import "package:flutter/material.dart";
import "package:trilhas_phb/constants/app_colors.dart";
import "package:trilhas_phb/models/hike.dart";
import "package:trilhas_phb/services/hike.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _hikeService = HikeService();
  final _hikes = <HikeModel>[];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHikes();
  }

  Future<void> _loadHikes() async {
    try {
      if (_isLoading) return;

      setState(() => _isLoading = true);

      final hikes = await _hikeService.getAll();

      setState(() {
        _isLoading = false;
        _hikes.insertAll(0, hikes);
      } );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      // TODO: Verificar porque não tá chegando aqui
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            SizedBox(
              height: 150,
              child: _hikes.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, value) {
                  return const SizedBox(width: 20);
                },
                itemCount: _hikes.length,
                itemBuilder: (context, index) {
                  final hike = _hikes[index];
                  return HikeCard(
                    position: index,
                    hike: hike,
                    hikes: _hikes,
                    height: 150,
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}

class HikeCard extends StatelessWidget {
  const HikeCard({
    super.key,
    required int position,
    required HikeModel hike,
    required List<HikeModel> hikes,
    required double height,
  }) :
    _height = height,
    _position = position,
    _hike = hike,
    _hikes = hikes;

  final int _position;
  final HikeModel _hike;
  final List<HikeModel> _hikes;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: EdgeInsets.only(
        left: _position == 0 ? 20.0 : 0.0,
        right: _position == _hikes.length - 1 ? 20.0 : 0.0
      ),
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: _height / 2,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(_hike.mainImage),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Text(
            _hike.name,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
