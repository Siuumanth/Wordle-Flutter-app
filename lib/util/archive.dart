
// Placeholder Container for each stage (left, middle, right)
/*class PlaceholderContainer extends StatelessWidget {
  final leaderBoardDetails details;
  final int rank;

  const PlaceholderContainer({
    super.key,
    required this.details,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(flex: rank, child: SizedBox()),
          Expanded(
            flex: 9,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: theme,
                    child: details.pfp != null
                        ? ClipOval(
                            child: Image.asset(
                                'assets/profiles/${details.pfp}.png'),
                          )
                        : const Icon(Icons.person, size: 40, color: white),
                  ),
                  Text(
                    details.username ?? "Player ${details.rank}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${details.score ?? 0} Points",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/