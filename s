import { Test, TestingModule } from '@nestjs/testing';
import { HealthCheckService } from './health-check.service';
import { DatabaseHealthIndicator, DNSHealthIndicator, TerminusModuleOptions } from '@nestjs/terminus';

describe('HealthCheckService', () => {
  let service: HealthCheckService;
  let dbHealthIndicator: DatabaseHealthIndicator;
  let dnsHealthIndicator: DNSHealthIndicator;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HealthCheckService,
        {
          provide: DatabaseHealthIndicator,
          useValue: { pingCheck: jest.fn() },
        },
        {
          provide: DNSHealthIndicator,
          useValue: { pingCheck: jest.fn() },
        },
      ],
    }).compile();

    service = module.get<HealthCheckService>(HealthCheckService);
    dbHealthIndicator = module.get<DatabaseHealthIndicator>(DatabaseHealthIndicator);
    dnsHealthIndicator = module.get<DNSHealthIndicator>(DNSHealthIndicator);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create terminus options with readiness and liveness endpoints', () => {
    const options: TerminusModuleOptions = service.createTerminusOptions();
    expect(options.endpoints).toHaveLength(2);

    const readinessEndpoint = options.endpoints.find(endpoint => endpoint.url === '/readiness');
    expect(readinessEndpoint).toBeDefined();

    const livenessEndpoint = options.endpoints.find(endpoint => endpoint.url === '/liveness');
    expect(livenessEndpoint).toBeDefined();
  });

  it('should call pingCheck for the database in readiness endpoint', async () => {
    const dbPingCheckSpy = jest.spyOn(dbHealthIndicator, 'pingCheck').mockResolvedValue({ status: 'ok' });
    const options: TerminusModuleOptions = service.createTerminusOptions();

    const readinessEndpoint = options.endpoints.find(endpoint => endpoint.url === '/readiness');
    await readinessEndpoint.healthIndicators[0]();

    expect(dbPingCheckSpy).toHaveBeenCalledWith('database');
  });

  it('should call pingCheck for the DNS in readiness endpoint', async () => {
    const dnsPingCheckSpy = jest.spyOn(dnsHealthIndicator, 'pingCheck').mockResolvedValue({ status: 'ok' });
    const options: TerminusModuleOptions = service.createTerminusOptions();

    const readinessEndpoint = options.endpoints.find(endpoint => endpoint.url === '/readiness');
    await readinessEndpoint.healthIndicators[1]();

    expect(dnsPingCheckSpy).toHaveBeenCalledWith('sgconnect-auth-server', process.env.OAUTH2_HEALTH_CHECK_URL);
  });
});

