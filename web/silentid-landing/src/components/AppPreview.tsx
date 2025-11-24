/**
 * App Preview Component
 * Shows multiple app screens in a grid layout
 * Source: claude.md Section 21 (Landing Page - App Preview Section)
 */

export default function AppPreview() {
  const screens = [
    {
      title: 'Trust Passport',
      description: 'Your complete trust profile at a glance',
      mockupContent: (
        <div className="space-y-4 p-6">
          <div className="text-center space-y-2">
            <div className="w-16 h-16 mx-auto bg-primary rounded-full flex items-center justify-center text-white text-2xl font-bold">
              S
            </div>
            <h3 className="font-semibold text-lg">Sarah M.</h3>
            <p className="text-sm text-neutral-600">@sarahtrusted</p>
          </div>
          <div className="bg-primary-light/30 rounded-lg p-4 text-center">
            <p className="text-4xl font-bold text-primary">847</p>
            <p className="text-xs text-neutral-600 mt-1">TrustScore</p>
            <div className="inline-block px-3 py-1 bg-success/20 text-success rounded-full text-xs font-semibold mt-2">
              Very High Trust
            </div>
          </div>
          <div className="space-y-2">
            <div className="flex items-center justify-between text-xs">
              <span className="text-neutral-600">Identity</span>
              <span className="font-semibold">200/200</span>
            </div>
            <div className="flex items-center justify-between text-xs">
              <span className="text-neutral-600">Evidence</span>
              <span className="font-semibold">280/300</span>
            </div>
            <div className="flex items-center justify-between text-xs">
              <span className="text-neutral-600">Behaviour</span>
              <span className="font-semibold">240/300</span>
            </div>
            <div className="flex items-center justify-between text-xs">
              <span className="text-neutral-600">Peer Verification</span>
              <span className="font-semibold">127/200</span>
            </div>
          </div>
        </div>
      ),
    },
    {
      title: 'Passwordless Login',
      description: 'Secure authentication without passwords',
      mockupContent: (
        <div className="space-y-4 p-6">
          <div className="text-center space-y-2 py-4">
            <h3 className="text-xl font-bold">Welcome to SilentID</h3>
            <p className="text-sm text-neutral-600">Your portable trust passport</p>
          </div>
          <div className="space-y-3">
            <button className="w-full bg-black text-white rounded-lg py-3 text-sm font-medium flex items-center justify-center gap-2">
              <svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
                <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09l.01-.01zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"/>
              </svg>
              Continue with Apple
            </button>
            <button className="w-full bg-white border-2 border-neutral-300 text-neutral-900 rounded-lg py-3 text-sm font-medium flex items-center justify-center gap-2">
              <svg className="w-5 h-5" viewBox="0 0 24 24">
                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
              </svg>
              Continue with Google
            </button>
            <button className="w-full bg-primary text-white rounded-lg py-3 text-sm font-medium">
              Continue with Email
            </button>
          </div>
          <p className="text-xs text-neutral-500 text-center pt-2">
            By continuing, you agree to SilentID's Terms & Privacy Policy
          </p>
        </div>
      ),
    },
    {
      title: 'Security Center',
      description: 'Real-time protection and monitoring',
      mockupContent: (
        <div className="space-y-4 p-6">
          <div className="text-center pb-2">
            <h3 className="text-lg font-bold">Security Center</h3>
            <p className="text-xs text-neutral-600">Your account is protected</p>
          </div>
          <div className="space-y-3">
            <div className="bg-success/10 border border-success/30 rounded-lg p-3">
              <div className="flex items-start gap-3">
                <div className="w-8 h-8 bg-success rounded-full flex items-center justify-center flex-shrink-0">
                  <svg className="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div className="flex-1">
                  <p className="text-sm font-semibold">Device Security</p>
                  <p className="text-xs text-neutral-600 mt-1">All checks passed</p>
                </div>
              </div>
            </div>
            <div className="bg-white border border-neutral-200 rounded-lg p-3">
              <div className="flex items-start gap-3">
                <div className="w-8 h-8 bg-primary-light rounded-full flex items-center justify-center flex-shrink-0">
                  <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                  </svg>
                </div>
                <div className="flex-1">
                  <p className="text-sm font-semibold">Email Breach Check</p>
                  <p className="text-xs text-neutral-600 mt-1">No breaches found</p>
                </div>
              </div>
            </div>
            <div className="bg-white border border-neutral-200 rounded-lg p-3">
              <div className="flex items-start gap-3">
                <div className="w-8 h-8 bg-primary-light rounded-full flex items-center justify-center flex-shrink-0">
                  <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                </div>
                <div className="flex-1">
                  <p className="text-sm font-semibold">Login Activity</p>
                  <p className="text-xs text-neutral-600 mt-1">3 devices active</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      ),
    },
  ];

  return (
    <section className="section-padding bg-neutral-50">
      <div className="container-custom">
        <div className="text-center space-y-4 mb-16">
          <h2 className="text-4xl md:text-5xl font-bold text-neutral-black">
            See How SilentID Works
          </h2>
          <p className="text-xl text-neutral-700 max-w-3xl mx-auto">
            Bank-grade security meets beautiful, simple design
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-8">
          {screens.map((screen, index) => (
            <div key={index} className="space-y-4">
              {/* Phone Mockup */}
              <div className="relative mx-auto" style={{ maxWidth: '280px' }}>
                {/* Phone Frame */}
                <div className="bg-white rounded-[2.5rem] shadow-2xl p-3 border-8 border-neutral-900">
                  {/* Notch */}
                  <div className="bg-neutral-900 h-6 rounded-b-2xl mx-auto mb-2" style={{ width: '120px' }} />

                  {/* Screen Content */}
                  <div className="bg-white rounded-2xl overflow-hidden border border-neutral-200">
                    <div className="aspect-[9/16] overflow-y-auto">
                      {screen.mockupContent}
                    </div>
                  </div>

                  {/* Home Indicator */}
                  <div className="bg-neutral-900 h-1 rounded-full mx-auto mt-2" style={{ width: '100px' }} />
                </div>
              </div>

              {/* Description */}
              <div className="text-center space-y-2">
                <h3 className="text-lg font-semibold text-neutral-black">
                  {screen.title}
                </h3>
                <p className="text-sm text-neutral-600">
                  {screen.description}
                </p>
              </div>
            </div>
          ))}
        </div>

        {/* Download CTA */}
        <div className="text-center mt-16 space-y-4">
          <p className="text-lg text-neutral-700">
            Available on iOS and Android
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <button className="btn-primary">
              Download on App Store
            </button>
            <button className="btn-secondary">
              Get it on Google Play
            </button>
          </div>
          <p className="text-sm text-neutral-500 pt-4">
            Coming soon • Join the waitlist to get early access
          </p>
        </div>
      </div>
    </section>
  );
}
