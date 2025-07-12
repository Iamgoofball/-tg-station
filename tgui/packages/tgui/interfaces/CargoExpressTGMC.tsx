import { AnimatedNumber, Box, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { CargoCatalog } from './Cargo/CargoCatalog';

type Data = {
  points: number;
};

export function CargoExpressTGMC(props) {
  const { data } = useBackend<Data>();

  return (
    <Window width={600} height={700} theme="syndicate">
      <Window.Content>
        <Stack fill vertical g={0}>
          <Stack.Item grow>
            <CargoExpressContent />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}

function CargoExpressContent(props) {
  const { act, data } = useBackend<Data>();
  const { points } = data;

  return (
    <Stack fill vertical g={0}>
      <Stack.Item>
        <Section
          title="Requisitions Express"
          buttons={
            <Box inline bold verticalAlign={'middle'}>
              <AnimatedNumber value={Math.round(points)} />
              {' credits'}
            </Box>
          }
        />
      </Stack.Item>
      <Stack.Item grow>
        <CargoCatalog express />
      </Stack.Item>
    </Stack>
  );
}
