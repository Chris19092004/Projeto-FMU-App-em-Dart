// DevSchool - mobile (Android) version, single file.
// Paste into https://dartpad.dev (Flutter) or use as lib/main.dart.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const DevSchoolApp());
}

// ---------------------------------------------------------------- App

class DevSchoolApp extends StatefulWidget {
  const DevSchoolApp({super.key});

  @override
  State<DevSchoolApp> createState() => _DevSchoolAppState();
}

class _DevSchoolAppState extends State<DevSchoolApp> {
  final ProgressController _progress = ProgressController();

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressScope(
      notifier: _progress,
      child: MaterialApp(
        title: 'DevSchool',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF04AA6D)),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF282A35),
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomeShell(),
      ),
    );
  }
}

// ---------------------------------------------------------------- Models

class Lesson {
  final String title;
  final String body;
  final String code;
  const Lesson({required this.title, required this.body, required this.code});
}

class Course {
  final String id;
  final String name;
  final String tagline;
  final String codeLanguage;
  final IconData icon;
  final Color color;
  final List<Lesson> lessons;
  const Course({
    required this.id,
    required this.name,
    required this.tagline,
    required this.codeLanguage,
    required this.icon,
    required this.color,
    required this.lessons,
  });
}

// ---------------------------------------------------------------- Progress

/// Completed lessons (in memory for now; save it to the device later).
class ProgressController extends ChangeNotifier {
  final Set<String> _done = {};

  String _key(String courseId, int index) => '$courseId:$index';

  bool isDone(String courseId, int index) => _done.contains(_key(courseId, index));

  int doneCount(Course course) => [
        for (var i = 0; i < course.lessons.length; i++)
          if (isDone(course.id, i)) i
      ].length;

  void markDone(String courseId, int index) {
    if (_done.add(_key(courseId, index))) notifyListeners();
  }

  void toggle(String courseId, int index) {
    final key = _key(courseId, index);
    if (!_done.remove(key)) _done.add(key);
    notifyListeners();
  }
}

class ProgressScope extends InheritedNotifier<ProgressController> {
  const ProgressScope({
    super.key,
    required ProgressController super.notifier,
    required super.child,
  });

  static ProgressController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ProgressScope>()!.notifier!;
}

// ---------------------------------------------------------------- Content

const List<Course> courses = [
  Course(
    id: 'html',
    name: 'HTML',
    tagline: 'A estrutura de qualquer página web.',
    codeLanguage: 'html',
    icon: Icons.html,
    color: Color(0xFFE44D26),
    lessons: [
      Lesson(
        title: 'Introdução ao HTML',
        body: 'HTML é a linguagem de marcação usada para estruturar páginas web. '
            'Ela descreve o conteúdo usando elementos chamados tags.',
        code: '''
<!DOCTYPE html>
<html>
  <body>
    <h1>Olá, mundo!</h1>
    <p>Minha primeira página.</p>
  </body>
</html>''',
      ),
      Lesson(
        title: 'Títulos e parágrafos',
        body: 'Os títulos vão de h1 (o mais importante) até h6. '
            'Textos comuns ficam dentro da tag p.',
        code: '''
<h1>Título principal</h1>
<h2>Subtítulo</h2>
<p>Um parágrafo de texto.</p>''',
      ),
      Lesson(
        title: 'Links',
        body: 'A tag a cria links. O atributo href indica para onde o link leva.',
        code: '''
<a href="https://exemplo.com">Visite o site</a>''',
      ),
    ],
  ),
  Course(
    id: 'css',
    name: 'CSS',
    tagline: 'Cores, fontes e layout para suas páginas.',
    codeLanguage: 'css',
    icon: Icons.css,
    color: Color(0xFF264DE4),
    lessons: [
      Lesson(
        title: 'Introdução ao CSS',
        body: 'CSS controla a aparência do HTML: cores, tamanhos, espaçamentos e posição.',
        code: '''
h1 {
  color: blue;
  text-align: center;
}''',
      ),
      Lesson(
        title: 'Seletores',
        body: 'Um seletor escolhe quais elementos recebem o estilo: '
            'por tag, por classe (.) ou por id (#).',
        code: '''
p { color: gray; }
.destaque { background: yellow; }
#topo { font-size: 24px; }''',
      ),
      Lesson(
        title: 'Cores e fundos',
        body: 'Cores podem ser nomes, valores hexadecimais ou rgb.',
        code: '''
body { background-color: #f1f1f1; }
h1 { color: rgb(4, 170, 109); }''',
      ),
    ],
  ),
  Course(
    id: 'js',
    name: 'JavaScript',
    tagline: 'Deixe suas páginas interativas.',
    codeLanguage: 'javascript',
    icon: Icons.javascript,
    color: Color(0xFFF0B400),
    lessons: [
      Lesson(
        title: 'Introdução ao JavaScript',
        body: 'JavaScript é a linguagem que dá comportamento às páginas web. '
            'O comando console.log mostra mensagens no console.',
        code: '''
console.log("Olá, mundo!");''',
      ),
      Lesson(
        title: 'Variáveis',
        body: 'Use let para valores que mudam e const para valores fixos.',
        code: '''
let nome = "Ana";
const idade = 25;
console.log(nome + " tem " + idade + " anos");''',
      ),
      Lesson(
        title: 'Funções',
        body: 'Funções agrupam um trecho de código que pode ser reutilizado.',
        code: '''
function somar(a, b) {
  return a + b;
}
console.log(somar(2, 3)); // 5''',
      ),
    ],
  ),
  Course(
    id: 'python',
    name: 'Python',
    tagline: 'Uma linguagem simples para começar a programar.',
    codeLanguage: 'python',
    icon: Icons.terminal,
    color: Color(0xFF3776AB),
    lessons: [
      Lesson(
        title: 'Introdução ao Python',
        body: 'Python tem uma sintaxe curta e fácil de ler. '
            'A função print mostra um texto na tela.',
        code: '''
print("Olá, mundo!")''',
      ),
      Lesson(
        title: 'Variáveis',
        body: 'Em Python você cria uma variável apenas atribuindo um valor a ela.',
        code: '''
nome = "Ana"
idade = 25
print(nome, "tem", idade, "anos")''',
      ),
      Lesson(
        title: 'Condições',
        body: 'Use if e else para executar código só quando uma condição for verdadeira. '
            'A indentação define o bloco.',
        code: '''
idade = 18
if idade >= 18:
    print("Maior de idade")
else:
    print("Menor de idade")''',
      ),
    ],
  ),
];

// ---------------------------------------------------------------- Widgets

class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key, required this.code, required this.language});

  final String code;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF282A35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text(language,
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const Spacer(),
                IconButton(
                  tooltip: 'Copiar código',
                  icon: const Icon(Icons.copy, size: 18, color: Colors.white70),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code.trim()));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Código copiado!')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SelectableText(
              code.trim(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Home (bottom tabs)

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tab == 0 ? 'DevSchool' : 'Meu progresso')),
      body: IndexedStack(
        index: _tab,
        children: const [CoursesTab(), ProgressTab()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Cursos',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Progresso',
          ),
        ],
      ),
    );
  }
}

void _openCourse(BuildContext context, Course course) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CourseScreen(course: course)),
  );
}

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final results = courses
        .where((c) => c.name.toLowerCase().contains(_query.trim().toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Aprenda a programar, passo a passo.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              hintText: 'Buscar linguagem',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('Nenhuma linguagem encontrada.'))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 190,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, i) => _CourseCard(
                    course: results[i],
                    done: progress.doneCount(results[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course, required this.done});

  final Course course;
  final int done;

  @override
  Widget build(BuildContext context) {
    final total = course.lessons.length;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openCourse(context, course),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: course.color.withValues(alpha: 0.15),
                child: Icon(course.icon, color: course.color),
              ),
              const Spacer(),
              Text(course.name, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                course.tagline,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: total == 0 ? 0 : done / total),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final total = courses.fold<int>(0, (sum, c) => sum + c.lessons.length);
    final done = courses.fold<int>(0, (sum, c) => sum + progress.doneCount(c));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: total == 0 ? 0 : done / total,
                  strokeWidth: 10,
                ),
                Center(
                  child: Text('$done/$total',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(child: Text('lições concluídas')),
        const SizedBox(height: 24),
        for (final c in courses)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: c.color.withValues(alpha: 0.15),
              child: Icon(c.icon, color: c.color),
            ),
            title: Text(c.name),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: LinearProgressIndicator(
                value: c.lessons.isEmpty ? 0 : progress.doneCount(c) / c.lessons.length,
              ),
            ),
            trailing: Text('${progress.doneCount(c)}/${c.lessons.length}'),
            onTap: () => _openCourse(context, c),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------- Course + lessons

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final progress = ProgressScope.of(context);
    final scheme = Theme.of(context).colorScheme;
    final total = course.lessons.length;
    final done = progress.doneCount(course);

    return Scaffold(
      appBar: AppBar(title: Text('Tutorial de ${course.name}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(course.tagline, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: total == 0 ? 0 : done / total),
          const SizedBox(height: 4),
          Text('$done de $total lições concluídas'),
          const SizedBox(height: 16),
          for (var i = 0; i < total; i++)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: progress.isDone(course.id, i) ? scheme.primary : null,
                  foregroundColor: progress.isDone(course.id, i) ? scheme.onPrimary : null,
                  child: progress.isDone(course.id, i)
                      ? const Icon(Icons.check)
                      : Text('${i + 1}'),
                ),
                title: Text(course.lessons[i].title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonScreen(course: course, initialIndex: i),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Lessons are pages: swipe left/right or use the bottom buttons.
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.course, this.initialIndex = 0});

  final Course course;
  final int initialIndex;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late final PageController _pages = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int page) => _pages.animateToPage(
        page,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final progress = ProgressScope.of(context);
    final isFirst = _index == 0;
    final isLast = _index == course.lessons.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('${course.name}  ${_index + 1}/${course.lessons.length}'),
      ),
      body: PageView.builder(
        controller: _pages,
        itemCount: course.lessons.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, i) => _LessonPage(course: course, index: i),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isFirst ? null : () => _go(_index - 1),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Anterior'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () {
                    progress.markDone(course.id, _index);
                    if (isLast) {
                      Navigator.pop(context);
                    } else {
                      _go(_index + 1);
                    }
                  },
                  icon: Icon(isLast ? Icons.flag : Icons.arrow_forward),
                  label: Text(isLast ? 'Concluir' : 'Próximo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonPage extends StatelessWidget {
  const _LessonPage({required this.course, required this.index});

  final Course course;
  final int index;

  @override
  Widget build(BuildContext context) {
    final lesson = course.lessons[index];
    final progress = ProgressScope.of(context);
    final isDone = progress.isDone(course.id, index);
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lesson.title, style: text.headlineSmall),
          const SizedBox(height: 12),
          Text(lesson.body, style: text.bodyLarge),
          const SizedBox(height: 20),
          Text('Exemplo', style: text.titleMedium),
          const SizedBox(height: 8),
          CodeBlock(code: lesson.code, language: course.codeLanguage),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => progress.toggle(course.id, index),
            icon: Icon(isDone ? Icons.check_circle : Icons.check_circle_outline),
            label: Text(isDone ? 'Lição concluída' : 'Marcar como concluída'),
          ),
        ],
      ),
    );
  }
}
