import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App com Abas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// Dados de cada aba: titulo, icone e a cor usada quando ela esta selecionada.
class _AbaInfo {
  const _AbaInfo({
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.corFundo,
  });

  final String titulo;
  final IconData icone;
  final Color cor;
  final Color corFundo;
}

const List<_AbaInfo> _abas = [
  _AbaInfo(
    titulo: 'Início',
    icone: Icons.home,
    cor: Color(0xFF1565C0), // azul
    corFundo: Color(0xFFE3F2FD),
  ),
  _AbaInfo(
    titulo: 'Notícias',
    icone: Icons.article,
    cor: Color(0xFFEF6C00), // laranja
    corFundo: Color(0xFFFFF3E0),
  ),
  _AbaInfo(
    titulo: 'Perfil',
    icone: Icons.person,
    cor: Color(0xFF2E7D32), // verde
    corFundo: Color(0xFFE8F5E9),
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _abaAtual = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _abas.length, vsync: this);
    // Atualiza as cores sempre que a aba muda (toque ou arraste).
    _tabController.addListener(() {
      if (_tabController.index != _abaAtual) {
        setState(() => _abaAtual = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aba = _abas[_abaAtual];

    return Scaffold(
      backgroundColor: aba.corFundo,
      appBar: AppBar(
        backgroundColor: aba.cor,
        foregroundColor: Colors.white,
        title: Text(aba.titulo),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            for (final a in _abas) Tab(icon: Icon(a.icone), text: a.titulo),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TelaInicio(),
          TelaNoticias(),
          TelaPerfil(),
        ],
      ),
    );
  }
}

/// Imagem vinda da internet com indicador de carregamento e aviso de erro,
/// para o app continuar funcionando mesmo sem conexao.
class ImagemDaRede extends StatelessWidget {
  const ImagemDaRede({
    super.key,
    required this.url,
    required this.largura,
    required this.altura,
    this.circular = false,
  });

  final String url;
  final double largura;
  final double altura;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final imagem = Image.network(
      url,
      width: largura,
      height: altura,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progresso) {
        if (progresso == null) return child;
        return SizedBox(
          width: largura,
          height: altura,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, erro, stack) => Container(
        width: largura,
        height: altura,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: Icon(Icons.image_not_supported,
            size: altura / 3, color: Colors.grey.shade600),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(circular ? altura / 2 : 12),
      child: imagem,
    );
  }
}

/// Aba 1 - Inicio: texto de boas-vindas e uma imagem.
class TelaInicio extends StatelessWidget {
  const TelaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo ao nosso aplicativo!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Use as abas acima para navegar entre as seções.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            const ImagemDaRede(
              url: 'https://picsum.photos/id/1018/600/400',
              largura: 300,
              altura: 200,
            ),
          ],
        ),
      ),
    );
  }
}

/// Aba 2 - Noticias: lista com manchetes ficticias.
class TelaNoticias extends StatelessWidget {
  const TelaNoticias({super.key});

  static const List<Map<String, String>> _manchetes = [
    {
      'titulo': 'Cidade inaugura novo parque tecnológico',
      'resumo': 'Espaço vai abrigar startups e laboratórios de pesquisa.',
    },
    {
      'titulo': 'Pesquisadores criam bateria que dura uma semana',
      'resumo': 'Nova tecnologia promete revolucionar os celulares.',
    },
    {
      'titulo': 'Flutter se torna o framework mais usado do ano',
      'resumo': 'Desenvolvedores apontam produtividade como principal motivo.',
    },
    {
      'titulo': 'Festival de música movimenta o centro da capital',
      'resumo': 'Evento reuniu mais de 50 mil pessoas no fim de semana.',
    },
    {
      'titulo': 'Time local vence campeonato pela terceira vez',
      'resumo': 'Final foi decidida nos pênaltis, diante da torcida.',
    },
    {
      'titulo': 'Projeto de reciclagem reduz lixo em 30%',
      'resumo': 'Iniciativa começou nos bairros da zona norte.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _manchetes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final noticia = _manchetes[index];
        return Card(
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFEF6C00),
              foregroundColor: Colors.white,
              child: Text('${index + 1}'),
            ),
            title: Text(
              noticia['titulo']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(noticia['resumo']!),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}

/// Aba 3 - Perfil: nome do usuario e sua imagem.
class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ImagemDaRede(
              url: 'https://picsum.photos/id/1005/300/300',
              largura: 160,
              altura: 160,
              circular: true,
            ),
            const SizedBox(height: 20),
            const Text(
              'Pedro Henrique',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Estudante de Desenvolvimento Mobile',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.email, color: Color(0xFF2E7D32)),
                    title: Text('pedro.henrique@email.com'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.phone, color: Color(0xFF2E7D32)),
                    title: Text('(00) 90000-0000'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Color(0xFF2E7D32)),
                    title: Text('Brasil'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
