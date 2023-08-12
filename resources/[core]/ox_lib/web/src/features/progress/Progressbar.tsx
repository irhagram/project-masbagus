import React from 'react';
import { Text, Flex, Box } from '@chakra-ui/react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { fetchNui } from '../../utils/fetchNui';

export interface ProgressbarProps {
  label: string;
  duration: number;
}

const Progressbar: React.FC = () => {
  const [visible, setVisible] = React.useState(false);
  const [label, setLabel] = React.useState('');
  const [duration, setDuration] = React.useState(0);
  const [cancelled, setCancelled] = React.useState(false);

  const progressComplete = () => {
    setVisible(false);
    fetchNui('progressComplete');
  };

  const progressCancel = () => {
    setCancelled(true);
    setVisible(false);
  };

  useNuiEvent('progressCancel', progressCancel);

  useNuiEvent<ProgressbarProps>('progress', (data) => {
    setCancelled(false);
    setVisible(true);
    setLabel(data.label);
    setDuration(data.duration);
  });

  return (
    <Flex h="30%" w="100%" position="absolute" bottom="0" justifyContent="center" alignItems="center">
      <Box width={350}>
        {visible && (
          <Box
            height={45}
            bg="rgba(0, 0, 0, 0.6)"
            textAlign="center"
            borderRadius="150px"
            boxShadow="0 10px 40px -10px #0091ff"
            overflow="hidden"
          >
            <Box
              height={45}
              onAnimationEnd={progressComplete}
              sx={
                !cancelled
                  ? {
                      width: '0%',
                      borderRadius: '150px',
                      backgroundColor: '#0091ff',
                      boxShadow:'2px -1px 10px 2px #0091ff, -2px 2px 15px 2px #0091ff',
                      animation: 'progress-bar linear',
                      animationDuration: `${duration}ms`,
                    }
                  : {
                      // Currently unused
                      width: '100%',
                      animationPlayState: 'paused',
                      backgroundColor: 'rgb(198, 40, 40)',
                    }
              }
            />
            <Text
              fontFamily="Inter"
              fontSize={20}
              fontWeight="light"
              position="absolute"
              top="50%"
              left="50%"
              transform="translate(-50%, -50%)"
            >
              {label}
            </Text>
          </Box>
        )}
      </Box>
    </Flex>
  );
};

export default Progressbar;