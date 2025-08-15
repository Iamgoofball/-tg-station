// Obnoxious advertisement with moving text and flashing colors
import '../styles/interfaces/Advertisement.scss';

import { useEffect, useRef, useState } from 'react';
import { Button, Icon, Modal, Section, Stack } from 'tgui-core/components';

import { backendSuspendStart, globalStore, useBackend } from '../backend';
import { getWindowSize, setWindowPosition } from '../drag';
import { Window } from '../layouts';

const pickRandomElement = (arr: string[]) =>
  arr[Math.floor(Math.random() * arr.length)];

type Data = {
  severity: number;
  customer: string;
};
const pixelRatio = window.devicePixelRatio ?? 1;
const screenSize: [number, number] = [
  window.screen.availWidth * pixelRatio,
  window.screen.availHeight * pixelRatio,
];
const winSize = getWindowSize();
const position = useRef<[number, number]>([0, 0]);
const useBouncer = (speed: number) => {
  const [enabled, setEnabled] = useState(true);
  const velocity = useRef<[number, number]>([
    (Math.random() > 0.5 ? 1 : -1) * (speed * 0.3), // Reduce speed to be less aggressive
    (Math.random() > 0.5 ? 0.8 : -0.8) * (speed * 0.3),
  ]);

  useEffect(() => {
    let raf: number;
    let last = performance.now();
    const step = (now: number) => {
      if (!enabled) return;
      const dt = Math.max(0.001, Math.min((now - last) / 1000, 0.05)); // Cap dt to prevent large jumps
      last = now;
      const screen: [number, number] = [
        window.screen.availWidth * pixelRatio,
        window.screen.availHeight * pixelRatio,
      ];
      const size = getWindowSize();
      const v = velocity.current;
      const p = position.current;
      // Integrate
      p[0] += v[0] * dt;
      p[1] += v[1] * dt;
      // Bounce
      if (p[0] < 0) {
        p[0] = 0;
        v[0] = Math.abs(v[0]);
      } else if (p[0] + size[0] > screen[0]) {
        p[0] = Math.max(0, screen[0] - size[0]);
        v[0] = -Math.abs(v[0]);
      }
      if (p[1] < 0) {
        p[1] = 0;
        v[1] = Math.abs(v[1]);
      } else if (p[1] + size[1] > screen[1]) {
        p[1] = Math.max(0, screen[1] - size[1]);
        v[1] = -Math.abs(v[1]);
      }
      setWindowPosition([p[0], p[1]]);
      // Use a slower update rate to maintain interactivity
      setTimeout(() => {
        raf = requestAnimationFrame(step);
      }, 50);
    };
    raf = requestAnimationFrame(step);
    return () => {
      setEnabled(false);
      cancelAnimationFrame(raf);
    };
  }, []); // Remove speed dependency to prevent recreation
};

const titleVariants = [
  'HOT MOTHS IN YOUR AREA',
  'LOSE FIFTY POUNDS IN A SHIFT',
  'FIND OUT THE TRUTH',
  'LIMITED TIME OFFER',
  'WARNING: SYSTEM BREACH',
  'EQUESTRIAN WOMEN GONE WILD',
  'DEFRAGMENT YOUR HARD DRIVE TODAY',
  'EXTEND YOUR SHUTTLE WARRANTY',
  "YOU WON'T BELIEVE",
];

const bodyVariants = [
  'I bought this and now HUNDREDS WANT ME!',
  "Come robust, M'lord.",
  '4 of 5 Medical Doctors recommend this supplement.',
  'Clean your hard-drive instantly with one weird trick!',
  'Get a grey-tide body with Scientist-level effort!',
  'Mares near you are single, ready to mingle, and have insane stamina!',
  'YOUR OPERATING SYSTEM IS INFECTED, CLICK NOW FOR SUPPORT!!!',
  "We're trying to reach you about your shuttle's extended warranty!",
  'Fundamentally evil people are REAL, click here to learn how to be an empath!',
  'Leaked footage of Nanotrasen CEOs at Spachemian Grove!',
  'Find the location of the PWS Khranitel Revolyutsii today!',
];
const purchasePhrases = [
  '!!BUY NOW!!',
  '!!ACT NOW!!',
  '!!INVEST NOW!!',
  '!!GET NOW!!',
  '!!SHOP NOW!!',
];

const pleaseDontCloseMeIWillCry = [
  'Closing now may leave you LIABLE!',
  'WARNING: System breach may get worse if you close this alert!',
  "If you leave me, I'll never love again!",
  'As your anti-virus, I advise you to not close this window.',
  "Are you sure you don't not want to not close this window?",
  'Closing this window is a binding contract. Are you sure?',
  'This is an official Central Command message; DO NOT CLOSE!',
  "You won't last five minutes without this deal!",
];

export const Advertisement = () => {
  const { act, data } = useBackend<Data>();
  const { severity } = data;

  const [header] = useState(pickRandomElement(titleVariants));
  const [body] = useState(pickRandomElement(bodyVariants));
  const [purchasePhrase] = useState(pickRandomElement(purchasePhrases));

  const [closePhrase, setClosePhrase] = useState('SOMETHING BROKE');

  const [showClosePrompt, setShowClosePrompt] = useState(false);

  useEffect(() => {
    const closeButton = document.getElementsByClassName('TitleBar__close');
    if (closeButton.length > 0) {
      closeButton[0].addEventListener('click', tryCloseWindow);
    }

    return () => {
      if (closeButton.length > 0) {
        closeButton[0].removeEventListener('click', tryCloseWindow);
      }
    };
  }, []);

  const [closePromptTimeout, setClosePromptTimeout] =
    useState<NodeJS.Timeout>();

  const [closePromptConfirmation, setClosePromptConfirmation] = useState(false);

  const actuallyCloseWindow = () => globalStore.dispatch(backendSuspendStart());

  const tryCloseWindow = (event: Event) => {
    event.preventDefault();
    event.stopPropagation();
    if (severity > 1) {
      actuallyCloseWindow();
      clearTimeout(closePromptTimeout);
    } else {
      setClosePromptConfirmation(false);
      setClosePhrase(pickRandomElement(pleaseDontCloseMeIWillCry));
      setShowClosePrompt(true);
      setClosePromptTimeout(
        setTimeout(() => {
          setShowClosePrompt(false);
        }, 3000),
      );
    }
  };

  const closePrompt = () => {
    setShowClosePrompt(false);
    clearTimeout(closePromptTimeout);
  };
  position.current = [
    Math.random() * Math.max(0, screenSize[0] - winSize[0]),
    Math.random() * Math.max(0, screenSize[1] - winSize[1]),
  ];
  setWindowPosition(position.current);
  return (
    <Window title={header} width={400} height={300} theme="retro">
      <Window.Content>
        {showClosePrompt && (
          <Modal>
            <Stack
              textAlign="center"
              fontSize="1.5em"
              vertical
              fill
              textColor="black"
            >
              <Stack.Item>{closePhrase}</Stack.Item>
              <Stack.Item style={{ display: 'flex', gap: '1em' }}>
                <Button
                  textAlign="center"
                  fontSize="1.2em"
                  onClick={() => {
                    closePrompt();
                    actuallyCloseWindow();
                  }}
                >
                  Close
                </Button>

                <Button
                  textAlign="center"
                  fontSize="1.2em"
                  onClick={() => closePrompt()}
                >
                  Back
                </Button>
              </Stack.Item>
              <Stack.Item>
                {severity < 2 && (
                  <Button.Checkbox
                    checked={closePromptConfirmation}
                    disabled={closePromptConfirmation}
                    onClick={() => {
                      setClosePromptConfirmation(!closePromptConfirmation);
                      act('toggle_close_perma');
                    }}
                  >
                    Do not reopen this window.
                  </Button.Checkbox>
                )}
              </Stack.Item>
            </Stack>
          </Modal>
        )}
        <Section className="Advertisement" fill align="center">
          <Stack textAlign="center" fontSize="1.5em" vertical fill>
            <Stack.Item maxWidth="24rem" align="center">
              <span className="Advertisement__marquee">{body}</span>
            </Stack.Item>
            <Stack.Item>
              <Button
                width="24rem"
                height="6rem"
                fontSize="2.5rem"
                textAlign="center"
                verticalAlign="center"
                verticalAlignContent="center"
                onClick={() => {
                  act('purchase');
                }}
              >
                <span className="Advertisement__Blink">{purchasePhrase}</span>
              </Button>
            </Stack.Item>
          </Stack>
          <div>
            <Icon
              className="Advertisement_DollarSign top-left"
              name="sack-dollar"
            />
          </div>
          <div>
            <Icon
              className="Advertisement_DollarSign top-right"
              name="sack-dollar"
            />
          </div>
          <div>
            <Icon
              className="Advertisement_DollarSign bottom-left"
              name="sack-dollar"
            />
          </div>
          <div>
            <Icon
              className="Advertisement_DollarSign bottom-right"
              name="sack-dollar"
            />
          </div>
        </Section>
      </Window.Content>
    </Window>
  );
};
