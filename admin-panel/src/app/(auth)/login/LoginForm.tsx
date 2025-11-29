'use client';

import { useState, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { KeyRound, Mail, Fingerprint, AlertCircle, Loader2 } from 'lucide-react';
import { Card, CardContent } from '@/components/ui';
import { Button } from '@/components/ui';
import { useAuth } from '@/lib/auth';
import { cn } from '@/lib/utils';

type AuthStep = 'email' | 'method' | 'otp' | 'passkey';

interface FormState {
  email: string;
  otp: string;
}

export function LoginForm() {
  const router = useRouter();
  const { login, initiatePasskeyAuth, verifyOtp, requestOtp } = useAuth();

  const [step, setStep] = useState<AuthStep>('email');
  const [form, setForm] = useState<FormState>({ email: '', otp: '' });
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [hasPasskey, setHasPasskey] = useState(false);

  // Check if email belongs to an admin with passkey
  const handleEmailSubmit = useCallback(async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (!form.email.trim()) {
      setError('Please enter your email address');
      return;
    }

    // Basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(form.email)) {
      setError('Please enter a valid email address');
      return;
    }

    setLoading(true);

    try {
      // Check if admin exists and has passkey
      const result = await login.checkAdmin(form.email);

      if (!result.success) {
        setError(result.error?.message || 'Unable to verify admin access');
        return;
      }

      setHasPasskey(result.data?.hasPasskey || false);
      setStep('method');
    } catch (_err) {
      setError('An unexpected error occurred. Please try again.');
    } finally {
      setLoading(false);
    }
  }, [form.email, login]);

  // Handle passkey authentication
  const handlePasskeyAuth = useCallback(async () => {
    setError(null);
    setLoading(true);

    try {
      const result = await initiatePasskeyAuth(form.email);

      if (!result.success) {
        setError(result.error?.message || 'Passkey authentication failed');
        return;
      }

      // Redirect to dashboard on success
      router.push('/dashboard');
    } catch (_err) {
      setError('Passkey authentication failed. Please try again or use OTP.');
    } finally {
      setLoading(false);
    }
  }, [form.email, initiatePasskeyAuth, router]);

  // Request OTP
  const handleRequestOtp = useCallback(async () => {
    setError(null);
    setLoading(true);

    try {
      const result = await requestOtp(form.email);

      if (!result.success) {
        setError(result.error?.message || 'Failed to send OTP');
        return;
      }

      setStep('otp');
    } catch (_err) {
      setError('Failed to send OTP. Please try again.');
    } finally {
      setLoading(false);
    }
  }, [form.email, requestOtp]);

  // Verify OTP
  const handleOtpSubmit = useCallback(async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (form.otp.length !== 6) {
      setError('Please enter the 6-digit code');
      return;
    }

    setLoading(true);

    try {
      const result = await verifyOtp(form.email, form.otp);

      if (!result.success) {
        setError(result.error?.message || 'Invalid or expired code');
        return;
      }

      // Redirect to dashboard on success
      router.push('/dashboard');
    } catch (_err) {
      setError('Verification failed. Please try again.');
    } finally {
      setLoading(false);
    }
  }, [form.email, form.otp, verifyOtp, router]);

  // Go back to previous step
  const handleBack = useCallback(() => {
    setError(null);
    if (step === 'otp') {
      setStep('method');
      setForm(prev => ({ ...prev, otp: '' }));
    } else if (step === 'method') {
      setStep('email');
    }
  }, [step]);

  // Render email input step
  const renderEmailStep = () => (
    <form onSubmit={handleEmailSubmit} className="space-y-4">
      <div>
        <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
          Admin Email
        </label>
        <div className="relative">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Mail className="h-5 w-5 text-gray-400" />
          </div>
          <input
            id="email"
            type="email"
            autoComplete="email"
            autoFocus
            value={form.email}
            onChange={(e) => setForm(prev => ({ ...prev, email: e.target.value }))}
            placeholder="admin@silentsale.co.uk"
            className={cn(
              'block w-full pl-10 pr-4 py-3 border rounded-lg text-gray-900',
              'placeholder:text-gray-400 focus:outline-none focus:ring-2',
              error
                ? 'border-status-danger focus:ring-status-danger'
                : 'border-admin-border focus:ring-silentid-purple focus:border-silentid-purple'
            )}
          />
        </div>
      </div>

      <Button
        type="submit"
        loading={loading}
        className="w-full"
        size="lg"
      >
        Continue
      </Button>
    </form>
  );

  // Render authentication method selection
  const renderMethodStep = () => (
    <div className="space-y-4">
      <p className="text-sm text-gray-600 text-center mb-6">
        Choose how you want to sign in
      </p>

      {hasPasskey && (
        <button
          onClick={handlePasskeyAuth}
          disabled={loading}
          className={cn(
            'w-full flex items-center gap-4 p-4 border rounded-lg',
            'text-left transition-all duration-200',
            'hover:border-silentid-purple hover:bg-silentid-purple-50',
            'focus:outline-none focus:ring-2 focus:ring-silentid-purple focus:ring-offset-2',
            'disabled:opacity-50 disabled:cursor-not-allowed',
            'border-admin-border bg-white'
          )}
        >
          <div className="flex-shrink-0 w-12 h-12 rounded-lg bg-silentid-purple-50 flex items-center justify-center">
            <Fingerprint className="w-6 h-6 text-silentid-purple" />
          </div>
          <div className="flex-1">
            <div className="font-medium text-gray-900">Passkey</div>
            <div className="text-sm text-gray-500">Use your biometric or security key</div>
          </div>
          {loading && <Loader2 className="w-5 h-5 animate-spin text-silentid-purple" />}
        </button>
      )}

      <button
        onClick={handleRequestOtp}
        disabled={loading}
        className={cn(
          'w-full flex items-center gap-4 p-4 border rounded-lg',
          'text-left transition-all duration-200',
          'hover:border-silentid-purple hover:bg-silentid-purple-50',
          'focus:outline-none focus:ring-2 focus:ring-silentid-purple focus:ring-offset-2',
          'disabled:opacity-50 disabled:cursor-not-allowed',
          'border-admin-border bg-white'
        )}
      >
        <div className="flex-shrink-0 w-12 h-12 rounded-lg bg-silentid-purple-50 flex items-center justify-center">
          <KeyRound className="w-6 h-6 text-silentid-purple" />
        </div>
        <div className="flex-1">
          <div className="font-medium text-gray-900">Email OTP</div>
          <div className="text-sm text-gray-500">Receive a one-time code via email</div>
        </div>
        {loading && !hasPasskey && <Loader2 className="w-5 h-5 animate-spin text-silentid-purple" />}
      </button>

      <button
        onClick={handleBack}
        className="w-full py-2 text-sm text-gray-500 hover:text-gray-700 transition-colors"
      >
        Use a different email
      </button>
    </div>
  );

  // Render OTP input step
  const renderOtpStep = () => (
    <form onSubmit={handleOtpSubmit} className="space-y-4">
      <div className="text-center mb-6">
        <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-silentid-purple-50 mb-3">
          <Mail className="w-6 h-6 text-silentid-purple" />
        </div>
        <p className="text-sm text-gray-600">
          We sent a 6-digit code to
        </p>
        <p className="font-medium text-gray-900">{form.email}</p>
      </div>

      <div>
        <label htmlFor="otp" className="block text-sm font-medium text-gray-700 mb-1">
          Verification Code
        </label>
        <input
          id="otp"
          type="text"
          inputMode="numeric"
          autoComplete="one-time-code"
          autoFocus
          maxLength={6}
          value={form.otp}
          onChange={(e) => {
            const value = e.target.value.replace(/\D/g, '');
            setForm(prev => ({ ...prev, otp: value }));
          }}
          placeholder="000000"
          className={cn(
            'block w-full px-4 py-3 border rounded-lg text-center text-2xl font-mono tracking-widest',
            'placeholder:text-gray-300 focus:outline-none focus:ring-2',
            error
              ? 'border-status-danger focus:ring-status-danger'
              : 'border-admin-border focus:ring-silentid-purple focus:border-silentid-purple'
          )}
        />
      </div>

      <Button
        type="submit"
        loading={loading}
        disabled={form.otp.length !== 6}
        className="w-full"
        size="lg"
      >
        Verify and Sign In
      </Button>

      <div className="flex items-center justify-between text-sm">
        <button
          type="button"
          onClick={handleBack}
          className="text-gray-500 hover:text-gray-700 transition-colors"
        >
          Back
        </button>
        <button
          type="button"
          onClick={handleRequestOtp}
          disabled={loading}
          className="text-silentid-purple hover:text-silentid-purple-dark transition-colors disabled:opacity-50"
        >
          Resend code
        </button>
      </div>
    </form>
  );

  return (
    <Card className="shadow-card">
      <CardContent className="p-8">
        {/* Error Alert */}
        {error && (
          <div className="mb-6 p-4 rounded-lg bg-status-danger-light border border-status-danger/20 flex items-start gap-3">
            <AlertCircle className="w-5 h-5 text-status-danger flex-shrink-0 mt-0.5" />
            <div className="text-sm text-status-danger">{error}</div>
          </div>
        )}

        {/* Step Content */}
        {step === 'email' && renderEmailStep()}
        {step === 'method' && renderMethodStep()}
        {step === 'otp' && renderOtpStep()}
      </CardContent>
    </Card>
  );
}
