import subprocess
from gi.repository import Nautilus, GObject, Notify, Gtk

class FaceConvMenu(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        Notify.init("FaceConv")

    def _show_dialog(self, title, message, message_type):
        """Cria uma janela de diálogo Gtk"""
        dialog = Gtk.MessageDialog(
            transient_for=None,
            flags=0,
            message_type=message_type,
            buttons=Gtk.ButtonsType.OK,
            text=title
        )
        dialog.format_secondary_text(message)
        dialog.run()
        dialog.destroy()

    def _run_faceconv(self, menu, files):
        filepath = files[0].get_location().get_path()
        
        try:
            result = subprocess.run(['/usr/local/bin/faceconv', filepath], 
                                     capture_output=True, text=True)

            if result.returncode == 0:
                # Janela de Sucesso
                self._show_dialog(
                    "Sucesso", 
                    "O avatar de login foi atualizado!", 
                    Gtk.MessageType.INFO
                )
            else:
                # Janela de Erro
                self._show_dialog(
                    "Erro no FaceConv", 
                    result.stderr or "Ocorreu um erro ao processar a imagem.", 
                    Gtk.MessageType.ERROR
                )
        except Exception as e:
            self._show_dialog("Erro de Sistema", str(e), Gtk.MessageType.ERROR)

    def get_file_items(self, *args):
        files = args[-1]
        if len(files) != 1:
            return

        file = files[0]
        if not file.is_directory() and file.get_mime_type().startswith('image/'):
            item = Nautilus.MenuItem(
                name='NautilusPython::FaceConv',
                label='Definir como Avatar de Login',
                icon='avatar-default'
            )
            item.connect('activate', self._run_faceconv, files)
            return [item]
        return