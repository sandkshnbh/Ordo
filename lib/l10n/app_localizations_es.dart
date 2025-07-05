// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_title => 'Ordo';

  @override
  String get settings => 'Configuración';

  @override
  String get add_task => 'Agregar Tarea';

  @override
  String get edit_task => 'Editar Tarea';

  @override
  String get save_task => 'Guardar Tarea';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String active_tasks(Object count) {
    return 'Tienes $count tarea activa';
  }

  @override
  String active_tasks_other(Object count) {
    return 'Tienes $count tareas activas';
  }

  @override
  String get no_tasks => 'No hay tareas actualmente';

  @override
  String get task_title => 'Título';

  @override
  String get task_description => 'Descripción (opcional)';

  @override
  String get priority => 'Prioridad';

  @override
  String get urgent => 'Urgente';

  @override
  String get important => 'Importante';

  @override
  String get normal => 'Normal';

  @override
  String get confirm_delete => 'Confirmar Eliminación';

  @override
  String get delete_question => '¿Estás seguro de que quieres eliminar esta tarea?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get unexpected_error => 'Ocurrió un error inesperado, por favor inténtalo de nuevo.';

  @override
  String get blur_selected_text => 'Desenfocar Texto Seleccionado';

  @override
  String get select_text_first => 'Selecciona texto primero para desenfocar.';

  @override
  String get language => 'Idioma';

  @override
  String get liquid_glass_theme => 'Tema Cristal Líquido';

  @override
  String get enable_liquid_glass => 'Habilitar Tema Cristal Líquido';

  @override
  String get liquid_glass_description => 'Aplicar diseño de cristal líquido con efectos visuales avanzados';

  @override
  String get profile_card_title => 'Tarjeta de Perfil';

  @override
  String get profile_card_subtitle => 'Desarrollador de Aplicaciones Flutter';

  @override
  String get profile_card_description => 'Soy Sand Kshnbh, un desarrollador de aplicaciones Flutter interesado en el desarrollo de software de código abierto.\nContáctame a través de: Telegram y Twitter X';

  @override
  String get profile_card_telegram => 'Mi Canal de Telegram';

  @override
  String get profile_card_twitter => 'Mi Cuenta de Twitter X';

  @override
  String get strike_style => 'Estilo de tachado';

  @override
  String get strike_straight => 'Recto';

  @override
  String get strike_zigzag => 'Zigzag';

  @override
  String get strike_scribble => 'Garabato';

  @override
  String get strike_dashed => 'Discontinuo';

  @override
  String get strike_wave => 'Onda';

  @override
  String get strike_aqua => 'Acuático';

  @override
  String get strike_flame => 'Llama';

  @override
  String get audio_feature_in_progress => 'La función de audio está en desarrollo';

  @override
  String get pin => 'Fijar';

  @override
  String get pin_feature_in_progress => 'La función de fijar está en desarrollo';
}
