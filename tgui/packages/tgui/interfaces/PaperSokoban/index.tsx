import { Window } from 'tgui/layouts';
import { Section } from 'tgui-core/components';

export function PaperSokoban(props) {
  return (
    <Window title="推箱子 (Sokoban)" width={500} height={550}>
      <Window.Content scrollable={false}>
        <Section fill fitted>
          <iframe
            src="https://www.puzzlescript.net/play.html?p=sokoban"
            style={{
              width: '100%',
              height: '100%',
              border: 'none',
            }}
          />
        </Section>
      </Window.Content>
    </Window>
  );
}
