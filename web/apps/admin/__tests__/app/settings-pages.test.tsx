import type { ReactNode } from 'react';
import { fireEvent, render, screen, waitFor } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { beforeEach, describe, expect, it, vi } from 'vitest';
import { apiGet, apiPatch } from '@/lib/api';
import SettingsPage from '@/app/[locale]/settings/page';
import SettingsBrandingPage from '@/app/[locale]/settings/branding/page';
import SettingsCompliancePage from '@/app/[locale]/settings/compliance/page';

const mockedApiGet = vi.mocked(apiGet);
const mockedApiPatch = vi.mocked(apiPatch);

function renderWithClient(children: ReactNode) {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false } },
  });
  return render(<QueryClientProvider client={queryClient}>{children}</QueryClientProvider>);
}

describe('admin settings pages', () => {
  beforeEach(() => {
    mockedApiGet.mockReset();
    mockedApiPatch.mockReset();
    mockedApiPatch.mockResolvedValue({});
  });

  it('loads and saves general settings with a real section payload', async () => {
    mockedApiGet.mockResolvedValue({
      section: 'general',
      settings: {
        platformName: 'Existing Flow',
        timezone: 'Asia/Bangkok',
        currency: 'vnd',
        maintenanceMode: false,
        registrationEnabled: true,
        notifications: { newOrder: true, support: true, newDriver: false, dailyDigest: true },
        security: {
          maxSessionMinutes: 360,
          maxLoginFailures: 4,
          requireAdminTwoFactor: true,
          loginAuditEnabled: true,
        },
        dataRetention: { autoDeleteLogs: true, deleteOldOrders: false },
      },
      updatedAt: null,
    });

    renderWithClient(<SettingsPage />);

    fireEvent.change(await screen.findByDisplayValue('Existing Flow'), {
      target: { value: 'Plaza 4 Pro' },
    });
    fireEvent.change(screen.getByDisplayValue('360'), { target: { value: '720' } });
    fireEvent.click(screen.getByRole('button', { name: 'save' }));

    await waitFor(() => expect(mockedApiPatch).toHaveBeenCalled());
    expect(mockedApiPatch).toHaveBeenCalledWith(
      '/admin/settings/general',
      expect.objectContaining({
        platformName: 'Plaza 4 Pro',
        currency: 'PEN',
        security: expect.objectContaining({ maxSessionMinutes: 720 }),
      }),
    );
  });

  it('shows a contract error instead of filling client defaults when general settings are incomplete', async () => {
    mockedApiGet.mockResolvedValue({
      section: 'general',
      settings: {
        platformName: 'Partial Flow',
        timezone: 'Asia/Bangkok',
        currency: 'PEN',
      },
      updatedAt: null,
    });

    renderWithClient(<SettingsPage />);

    expect(await screen.findByText('contractErrorTitle')).toBeInTheDocument();
    expect(screen.queryByDisplayValue('Partial Flow')).not.toBeInTheDocument();
    expect(mockedApiPatch).not.toHaveBeenCalled();
  });

  it('does not save invalid numeric settings as silent defaults', async () => {
    mockedApiGet.mockResolvedValue({
      section: 'general',
      settings: {
        platformName: 'Existing Flow',
        timezone: 'Asia/Bangkok',
        currency: 'vnd',
        maintenanceMode: false,
        registrationEnabled: true,
        notifications: { newOrder: true, support: true, newDriver: false, dailyDigest: true },
        security: {
          maxSessionMinutes: 360,
          maxLoginFailures: 4,
          requireAdminTwoFactor: true,
          loginAuditEnabled: true,
        },
        dataRetention: { autoDeleteLogs: true, deleteOldOrders: false },
      },
      updatedAt: null,
    });

    renderWithClient(<SettingsPage />);

    fireEvent.change(await screen.findByDisplayValue('360'), { target: { value: '0' } });
    fireEvent.click(screen.getByRole('button', { name: 'save' }));

    expect(await screen.findByText('validationError')).toBeInTheDocument();
    expect(mockedApiPatch).not.toHaveBeenCalled();
  });

  it('loads and saves branding settings without fake upload inputs', async () => {
    mockedApiGet.mockResolvedValue({
      section: 'branding',
      settings: {
        platformName: 'Plaza 4',
        tagline: 'Existing tagline',
        supportEmail: 'ops@plaza4.pe',
        contactPhone: '+84 123',
        primaryColor: '#111111',
        successColor: '#222222',
        logoUrl: 'https://cdn.plaza4.pe/logo.svg',
      },
      updatedAt: null,
    });

    renderWithClient(<SettingsBrandingPage />);

    expect(screen.queryByLabelText(/upload/i)).not.toBeInTheDocument();
    fireEvent.change(await screen.findByDisplayValue('Existing tagline'), {
      target: { value: 'Real delivery operations' },
    });
    fireEvent.change(screen.getByDisplayValue('https://cdn.plaza4.pe/logo.svg'), {
      target: { value: '' },
    });
    fireEvent.click(screen.getByRole('button', { name: 'save' }));

    await waitFor(() => expect(mockedApiPatch).toHaveBeenCalled());
    expect(mockedApiPatch).toHaveBeenCalledWith(
      '/admin/settings/branding',
      expect.objectContaining({
        tagline: 'Real delivery operations',
        primaryColor: '#111111',
        successColor: '#222222',
        logoUrl: null,
      }),
    );
  });

  it('loads and saves compliance settings against the compliance section', async () => {
    mockedApiGet.mockResolvedValue({
      section: 'compliance',
      settings: {
        privacyUrl: 'https://plaza4.pe/privacy',
        auditRetentionDays: 180,
        orderRetentionDays: 365,
        userDataRetentionDays: 730,
        consentBannerEnabled: true,
        dataExportRequestsEnabled: true,
        deletionRequestsEnabled: true,
        jurisdiction: 'Vietnam',
        vatEnabled: true,
        kycReviewRequired: true,
        supportSlaBusinessHours: 'ICT Mon-Sat 08:00-20:00',
        exportRetentionHours: 24,
      },
      updatedAt: null,
    });

    renderWithClient(<SettingsCompliancePage />);

    fireEvent.change(await screen.findByDisplayValue('https://plaza4.pe/privacy'), {
      target: { value: 'https://plaza4.pe/legal/privacy' },
    });
    fireEvent.change(screen.getByDisplayValue('180'), { target: { value: '365' } });
    fireEvent.click(screen.getByRole('button', { name: 'save' }));

    await waitFor(() => expect(mockedApiPatch).toHaveBeenCalled());
    expect(mockedApiPatch).toHaveBeenCalledWith(
      '/admin/settings/compliance',
      expect.objectContaining({
        privacyUrl: 'https://plaza4.pe/legal/privacy',
        auditRetentionDays: 365,
        supportSlaBusinessHours: 'ICT Mon-Sat 08:00-20:00',
      }),
    );
  });
});
