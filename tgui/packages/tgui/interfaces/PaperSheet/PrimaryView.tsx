import { Component, createRef, type RefObject } from 'react';
import { Box, Button, Flex, Section, TextArea } from 'tgui-core/components';

import { useBackend, useLocalState } from '../../backend';
import { TEXTAREA_INPUT_HEIGHT } from './constants';
import { PreviewView } from './Preview';
import { PaperSheetStamper } from './Stamper';
import { InteractionType, type PaperContext, type PaperInput } from './types';

// Overarching component that holds the primary view for papercode.
export class PrimaryView extends Component {
  scrollableRef: RefObject<HTMLDivElement | null>;
  lastDistanceFromBottom: number;
  onScrollHandler: (this: GlobalEventHandlers, ev: Event) => any;

  constructor(props) {
    super(props);
    this.scrollableRef = createRef();
    this.lastDistanceFromBottom = 0;

    this.onScrollHandler = (ev) => {
      const scrollable = ev.currentTarget as HTMLDivElement;
      if (scrollable) {
        this.lastDistanceFromBottom =
          scrollable.scrollHeight - scrollable.scrollTop;
      }
    };
  }

  render() {
    const { act, data } = useBackend<PaperContext>();
    const {
      raw_text_input,
      raw_field_input,
      default_pen_font,
      default_pen_color,
      paper_color,
      held_item_details,
      max_length,
    } = data;

    const useFont = held_item_details?.font || default_pen_font;
    const useColor = held_item_details?.color || default_pen_color;
    const useBold = held_item_details?.use_bold || false;

    const [inputFieldData, setInputFieldData] = useLocalState(
      'inputFieldData',
      {},
    );

    const [textAreaText, setTextAreaText] = useLocalState('textAreaText', '');
    
    // 新增：用來切換是否要玩 PuzzleScript Sokoban 遊戲
    const [playingGame, setPlayingGame] = useLocalState('playingGame', false);

    const interactMode =
      held_item_details?.interaction_mode || InteractionType.reading;

    const savableData =
      textAreaText.length || Object.keys(inputFieldData).length;

    const dmCharacters =
      raw_text_input?.reduce((lhs: number, rhs: PaperInput) => {
        return lhs + rhs.raw_text.length;
      }, 0) || 0;

    const usedCharacters = dmCharacters + textAreaText.length;
    const tooManyCharacters = usedCharacters > max_length;
    const canEdit = interactMode === InteractionType.writing;

    return (
      <>
        <PaperSheetStamper scrollableRef={this.scrollableRef} />
        <Flex direction="column" fillPositionedParent>
          {/* 頂部控制列：加入切換 PuzzleScript 遊戲的按鈕 */}
          <Flex.Item>
            <Section fitted>
              <Button
                icon={playingGame ? 'file-alt' : 'gamepad'}
                content={playingGame ? 'View Paper' : 'Play Sokoban (PuzzleScript)'}
                onClick={() => setPlayingGame(!playingGame)}
                fluid
              />
            </Section>
          </Flex.Item>

          <Flex.Item grow={3} basis={1}>
            {playingGame ? (
              // 嵌入 PuzzleScript Sokoban 遊戲
              <Section fill title="PuzzleScript - Sokoban">
                <Box height="100%" width="100%">
                  <iframe
                    src="https://www.puzzlescript.net/play.html?p=sokoban"
                    style={{ width: '100%', height: '100%', border: 'none' }}
                    title="Sokoban PuzzleScript"
                  />
                </Box>
              </Section>
            ) : (
              <PreviewView
                key={`${raw_field_input?.length || 0}_${
                  raw_text_input?.length || 0
                }`}
                scrollableRef={this.scrollableRef}
                handleOnScroll={this.onScrollHandler}
                textArea={textAreaText}
                canEdit={canEdit}
              />
            )}
          </Flex.Item>

          {canEdit && !playingGame && (
            <Flex.Item shrink={1} height={`${TEXTAREA_INPUT_HEIGHT}px`}>
              <Section
                title="Insert Text"
                fitted
                fill
                buttons={
                  <>
                    <Box
                      inline
                      pr={'5px'}
                      color={tooManyCharacters ? 'bad' : 'default'}
                    >
                      {`${usedCharacters} / ${max_length}`}
                    </Box>
                    <Button.Confirm
                      disabled={!savableData || tooManyCharacters}
                      color="good"
                      onClick={() => {
                        if (textAreaText.length) {
                          act('add_text', { text: textAreaText });
                          setTextAreaText('');
                        }
                        if (Object.keys(inputFieldData).length) {
                          act('fill_input_field', {
                            field_data: inputFieldData,
                          });
                          setInputFieldData({});
                        }
                      }}
                    >
                      Save
                    </Button.Confirm>
                  </>
                }
              >
                <TextArea
                  style={{ border: 'none' }}
                  value={textAreaText}
                  textColor={useColor}
                  fontFamily={useFont}
                  bold={useBold}
                  height="100%"
                  fluid
                  backgroundColor={paper_color}
                  onChange={(value) => {
                    setTextAreaText(value);

                    if (this.scrollableRef.current) {
                      const thisDistFromBottom =
                        this.scrollableRef.current.scrollHeight -
                        this.scrollableRef.current.scrollTop;
                      this.scrollableRef.current.scrollTop +=
                        thisDistFromBottom - this.lastDistanceFromBottom;
                    }
                  }}
                />
              </Section>
            </Flex.Item>
          )}
        </Flex>
      </>
    );
  }
}
