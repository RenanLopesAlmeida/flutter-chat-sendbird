part of '../chat_page.dart';

class _AppBarDoubtChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            margin: EdgeInsets.only(right: 8),
            color: Colors.deepPurple,
          ),
          Text(
            'Matemática',
            style: Theme.of(context).textTheme.caption?.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: InkWell(onTap: () {}, child: CircleAvatar()),
        ),
      ],
    );
  }
}
