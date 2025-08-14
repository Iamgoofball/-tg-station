// Obnoxious advertisement with moving text and flashing colors
import '../styles/interfaces/Advertisement.scss';

import { useEffect, useState } from 'react';
import { Box, Button, Modal, Section, Stack } from 'tgui-core/components';

import { backendSuspendStart, globalStore, useBackend } from '../backend';
import { getWindowPosition, setWindowPosition } from '../drag';
import { Window } from '../layouts';
import { logger } from '../logging';

const pickRandomElement = (arr: string[]) =>
  arr[Math.floor(Math.random() * arr.length)];

export const Advertisement = () => {
  const { act } = useBackend();
  const titleVariants = [
    'BUY MORE STUFF',
    'YOU NEED THIS',
    "DON'T MISS OUT",
    'LIMITED TIME OFFER',
    'EXCLUSIVE DEAL',
    'BEST PRICE EVER',
    'HURRY UP',
    'ACT NOW',
    'GET IT WHILE IT LASTS',
  ];

  const bodyVariants = [
    'This is the best product you will ever buy!',
    "You can't live without this!",
    'Everyone is talking about this!',
    'Your life will change forever with this!',
    "Don't be the last to get it!",
    'Join the thousands who already love it!',
    'This is a once-in-a-lifetime opportunity!',
    'You deserve the best, and this is it!',
    'Imagine how great you will feel with this!',
    'Your friends will be jealous when they see you with this!',
  ];
  // keep it same length
  const purchasePhrases = [
    'Buy Now',
    'Get Yours',
    'Order Today',
    'Claim Yours',
    'Shop Now',
    'Grab It',
    "Don't Wait",
    'Take Action',
    'Secure Yours',
    'Limited Stock',
  ];

  const pleaseDontCloseMeIWillCry = [
    "Please don't close me, I'll cry!",
    "I'm begging you, don't close this window!",
    'If you close me, I will be sad forever!',
    'Closing this window will break my heart!',
    "I can't handle the rejection, please stay!",
    "Don't leave me alone, I need you!",
    "I promise to be good, just don't close me!",
    'I will miss you if you close this window!',
  ];

  const intensity: number = 3;

  const colorVariants = ['red', 'blue', 'green', 'yellow', 'purple', 'orange'];
  const [header, setHeader] = useState(pickRandomElement(titleVariants));
  const [color, setColor] = useState(pickRandomElement(colorVariants));
  const [backgroundColor, setBackgroundColor] = useState(
    pickRandomElement(colorVariants),
  );
  const [body, setBody] = useState(pickRandomElement(bodyVariants));
  const [purchasePhrase, setPurchasePhrase] = useState(
    pickRandomElement(purchasePhrases),
  );

  const [closePhrase, setClosePhrase] = useState('SOMETHING BROKE');

  const [showClosePrompt, setShowClosePrompt] = useState(false);

  // random value between 10 and 20
  const randomValue = Math.floor(Math.random() * 11) + 10;

  useEffect(() => {
    const backgroundInterval = setInterval(() => {
      // randomly change one of the header, body, or color
      const changeType = Math.round(Math.random() * 3.1);

      switch (changeType) {
        case 0:
          setColor(pickRandomElement(colorVariants));
          break;
        case 1:
          setHeader(pickRandomElement(titleVariants));
          break;
        case 2:
          setBody(pickRandomElement(bodyVariants));
          break;
        case 3:
          setBackgroundColor(pickRandomElement(colorVariants));
          break;
      }
    }, randomValue * 30);

    const movementInterval = setInterval(
      () => annoyingScreenMovement(),
      randomValue,
    );

    const closeButton = document.getElementsByClassName('TitleBar__close');
    if (closeButton.length > 0) {
      closeButton[0].addEventListener('click', tryCloseWindow);
    }

    return () => {
      clearInterval(backgroundInterval);
      clearInterval(movementInterval);
      if (closeButton.length > 0) {
        closeButton[0].removeEventListener('click', tryCloseWindow);
      }
    };
  }, []);

  const [closePromptTimeout, setClosePromptTimeout] =
    useState<NodeJS.Timeout>();

  const [closePromptConfirmation, setClosePromptConfirmation] = useState(false);
  const [direction, setDirection] = useState([1, 1]);

  const annoyingScreenMovement = () => {
    const currentPosition = getWindowPosition();
    const newVector = [
      currentPosition[0] + direction[0] * 10,
      currentPosition[1] + direction[1] * 10,
    ];
    const screenWidth = window.screenLeft;
    const screenHeight = window.screenTop;
    logger.debug(
      `Current position: ${currentPosition}, New vector: ${newVector}, Screen width: ${screenWidth}, Screen height: ${screenHeight}`,
    );
    // Check if the new position is out of bounds
    if (newVector[0] < 0 || newVector[0] > screenWidth - 400) {
      // Reverse direction on x-axis
      setDirection([direction[0] * -1, direction[1]]);
    }
    if (newVector[1] < 0 || newVector[1] > screenHeight - 300) {
      // Reverse direction on y-axis
      setDirection([direction[0], direction[1] * -1]);
    }
    // move diagonally until it hits the edge of the screen, then reverse direction
    // const newVector = vecAdd(
    //   [...currentPosition],
    //   [
    //     Math.floor(Math.random() * 20) - 10,
    //     Math.floor(Math.random() * 20) - 10,
    //   ],
    // );
    logger.debug(
      `Moving advertisement window from ${currentPosition} to ${newVector}`,
    );
    setWindowPosition(newVector as [number, number]);
  };

  const actuallyCloseWindow = () => globalStore.dispatch(backendSuspendStart());

  const tryCloseWindow = (event: Event) => {
    event.preventDefault();
    event.stopPropagation();
    if (intensity < 2) {
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

  return (
    <Window title={header} width={400} height={300} theme="advertisement">
      <Window.Content scrollable backgroundColor={backgroundColor}>
        {showClosePrompt && (
          <Modal>
            <Stack
              color={color}
              textAlign="center"
              fontSize="1.5em"
              vertical
              fill
            >
              <Stack.Item>{closePhrase}</Stack.Item>
              <Stack.Item style={{ display: 'flex', gap: '1em' }}>
                <Button
                  color={color}
                  textAlign="center"
                  fontSize="1.2em"
                  onClick={() => {
                    closePrompt();
                    act('delayed-reopen');
                    actuallyCloseWindow();
                  }}
                >
                  Close Anyway
                </Button>

                <Button
                  color={color}
                  textAlign="center"
                  fontSize="1.2em"
                  onClick={() => closePrompt()}
                >
                  Keep It Open
                </Button>
              </Stack.Item>
              <Stack.Item>
                {intensity >= 3 && (
                  <Button.Checkbox
                    checked={closePromptConfirmation}
                    onClick={() =>
                      setClosePromptConfirmation(!closePromptConfirmation)
                    }
                  >
                    Are you SURE?
                  </Button.Checkbox>
                )}
              </Stack.Item>
            </Stack>
          </Modal>
        )}

        <Section
          className="Advertisement"
          backgroundColor={backgroundColor}
          fill
        >
          <Box
            color={color}
            textAlign="center"
            fontSize="2em"
            verticalAlign="center"
            className="Advertisement__MovingText"
          >
            {body}
          </Box>
          <Button
            width="6rem"
            textAlign="center"
            verticalAlign="center"
            verticalAlignContent="center"
            className="Advertisement__SpinningButton"
            onClick={() => {
              act('purchase');
              setPurchasePhrase(pickRandomElement(purchasePhrases));
            }}
          >
            {purchasePhrase}
          </Button>
          <div className="Advertisement_DollarSign top-left">$</div>
          <div className="Advertisement_DollarSign top-right">$</div>
          <div className="Advertisement_DollarSign bottom-left">$</div>
          <div className="Advertisement_DollarSign bottom-right">$</div>
        </Section>
      </Window.Content>
    </Window>
  );
};
