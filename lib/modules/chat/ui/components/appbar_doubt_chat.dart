part of '../chat_page.dart';

class _AppBarDoubtChat extends StatelessWidget {
  const _AppBarDoubtChat({required this.handlePickImage});
  final Function(int index) handlePickImage;

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
        PopupMenuButton<int>(
          onSelected: handlePickImage,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<int>(
                  value: 0, child: Text('Enviar Foto da galeria'))
            ];
          },
        ),
      ],
    );
  }
}
