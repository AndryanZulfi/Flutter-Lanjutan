import 'package:bahan_workshop/models/news_response.dart';
import 'package:bahan_workshop/providers/news_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsScreen extends ConsumerWidget {

  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(newsProvider.notifier).reload();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: news.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Error: $err"),
              FilledButton(
                  onPressed: (){
                    ref.read(newsProvider.notifier).reload();
                  },
                  child: Text("Refresh")
              )
            ],
          ),
        ),
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final data = list[index];
            return cardNews(data);
          },
        ),
      ),
    );
  }

  Widget cardNews(Articles article){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 128,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.network(
                  article.urlToImage ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stacktrace){
                    return Icon(Icons.image_not_supported);
                  },
                  loadingBuilder: (context, child, progress){
                    if (progress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        article.title ?? "no title",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(article.source?.name ?? "no source")
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}
