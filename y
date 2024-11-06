import { Controller, Get } from '@nestjs/common';
import { HealthCheckService } from './health-check.service';  // Ensure the path is correct
import { TerminusModuleOptions } from '@nestjs/terminus';

@Controller('health')
export class HealthController {
  constructor(private readonly healthCheckService: HealthCheckService) {}

  @Get('/readiness')
  async readiness() {
    const options: TerminusModuleOptions = this.healthCheckService.createTerminusOptions();
    const readinessEndpoint = options.endpoints.find(endpoint => endpoint.url === '/readiness');
    if (readinessEndpoint) {
      return readinessEndpoint.healthIndicators[0]();
    }
    return { message: 'Readiness check not configured' };
  }

  @Get('/liveness')
  async liveness() {
    const options: TerminusModuleOptions = this.healthCheckService.createTerminusOptions();
    const livenessEndpoint = options.endpoints.find(endpoint => endpoint.url === '/liveness');
    if (livenessEndpoint) {
      return livenessEndpoint.healthIndicators[0]();
    }
    return { message: 'Liveness check not configured' };
  }
}
