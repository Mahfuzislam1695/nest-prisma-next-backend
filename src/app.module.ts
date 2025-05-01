import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
    }),
    ServeStaticModule.forRootAsync({
      useFactory: (config: ConfigService) => {
        const uploadPath = config.get<string>('storage.destination', './uploads');
        return [{
          rootPath: join(__dirname, '..', uploadPath),
          serveRoot: '/fonts',
        }];
      },
      inject: [ConfigService],
    }),
    PrismaModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
