import { Test, TestingModule } from '@nestjs/testing';
import { HealthController } from './health.controller';
import { HealthCheckService } from './health-check.service';

describe('HealthController', () => {
  let controller: HealthController;
  let healthCheckService: HealthCheckService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [HealthController],
      providers: [
        {
          provide: HealthCheckService,
          useValue: {
            createTerminusOptions: jest.fn().mockReturnValue({
              endpoints: [
                {
                  url: '/readiness',
                  healthIndicators: [jest.fn().mockResolvedValue({ status: 'ok' })],
                },
                {
                  url: '/liveness',
                  healthIndicators: [jest.fn().mockResolvedValue({ api: { status: 'up and running' } })],
                },
              ],
            }),
          },
        },
      ],
    }).compile();

    controller = module.get<HealthController>(HealthController);
    healthCheckService = module.get<HealthCheckService>(HealthCheckService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should return readiness status', async () => {
    const readinessStatus = await controller.readiness();
    expect(readinessStatus).toEqual({ status: 'ok' });
  });

  it('should return liveness status', async () => {
    const livenessStatus = await controller.liveness();
    expect(livenessStatus).toEqual({ api: { status: 'up and running' } });
  });
});
