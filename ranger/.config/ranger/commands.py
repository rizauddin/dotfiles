from ranger.api.commands import Command
import subprocess

class z(Command):
    """:z [query]
    Jump to a directory using zoxide
    """

    def execute(self):
        query = self.arg(1) if self.arg(1) else None
        try:
            # Ask zoxide for the best match
            if query:
                target = subprocess.check_output(['zoxide', 'query', query], text=True).strip()
            else:
                # No argument: use interactive mode (fzf style)
                target = subprocess.check_output(['zoxide', 'query', '-i'], text=True).strip()

            self.fm.cd(target)
        except subprocess.CalledProcessError:
            self.fm.notify("No match found in zoxide database.", bad=True)
