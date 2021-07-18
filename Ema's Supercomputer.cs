using System;
using System.Linq;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.Globalization;
using System.Collections.Generic;
using System.Threading;
using kp.Algo;
using kp.Algo.IO;

namespace CodeForces
{
    internal class Solution
    {
        const int StackSize = 20 * 1024 * 1024;

        private void Solve()
        {
            int rows = NextInt();
            int cols = NextInt();
            var s = new string[rows];
            for (int i = 0; i < rows; i++)
            {
                s[i] = NextLine().Trim();
            }
            int res = 0;
            var w = new int[rows, cols];
            int step = 0;
            for (int i = 0; i < rows; i++)
            {
                for (int j = 0; j < cols; j++)
                {
                    if (s[i][j] == 'G')
                    {
                        w[i, j] = ++step;
                        int ur = i, dr = i, lc = j, rc = j;
                        var sq = 1;
                        var len = 0;
                        while (true)
                        {
                            for (int ii = 0; ii < rows; ii++)
                            {
                                for (int jj = 0; jj < cols; jj++)
                                {
                                    if (s[ii][jj] == 'G' && (ii != i || jj != j))
                                    {
                                        int ur2 = ii, dr2 = ii, lc2 = jj, rc2 = jj;
                                        var sq2 = 1;
                                        while (true)
                                        {
                                            res = Math.Max(res, sq * sq2);

                                            if (--ur2 < 0 || s[ur2][jj] != 'G' || w[ur2, jj] == step) break;
                                            if (++dr2 == rows || s[dr2][jj] != 'G' || w[dr2, jj] == step) break;
                                            if (--lc2 < 0 || s[ii][lc2] != 'G' || w[ii, lc2] == step) break;
                                            if (++rc2 == cols || s[ii][rc2] != 'G' || w[ii, rc2] == step) break;
                                            sq2 += 4;
                                        }
                                    }
                                }
                            }

                            if (--ur < 0 || s[ur][j] != 'G') break;
                            if (++dr == rows || s[dr][j] != 'G') break;
                            if (--lc < 0 || s[i][lc] != 'G') break;
                            if (++rc == cols || s[i][rc] != 'G') break;
                            sq += 4;
                            ++len;
                            w[ur, j] = step;
                            w[dr, j] = step;
                            w[i, lc] = step;
                            w[i, rc] = step;
                        }
                    }
                }
            }

            Out.WriteLine(res);
        }

        #region Local wireup

        public int[] NextIntArray(int size)
        {
            var res = new int[size];
            for (int i = 0; i < size; ++i) res[i] = NextInt();
            return res;
        }

        public long[] NextLongArray(int size)
        {
            var res = new long[size];
            for (int i = 0; i < size; ++i) res[i] = NextLong();
            return res;
        }

        public double[] NextDoubleArray(int size)
        {
            var res = new double[size];
            for (int i = 0; i < size; ++i) res[i] = NextDouble();
            return res;
        }

        public int NextInt()
        {
            return _in.NextInt();
        }

        public long NextLong()
        {
            return _in.NextLong();
        }

        public string NextLine()
        {
            return _in.NextLine();
        }

        public double NextDouble()
        {
            return _in.NextDouble();
        }

        Scanner _in;
        static readonly TextWriter Out = Console.Out;

        void Start()
        {
#if KP_HOME
            _in = new Scanner("input.txt");
            var timer = new Stopwatch();
            timer.Start();
#else
            _in = new Scanner( Console.In, false );
#endif
            var t = new Thread(Solve, StackSize);
            t.Start();
            t.Join();
#if KP_HOME
            timer.Stop();
            Console.WriteLine(string.Format(CultureInfo.InvariantCulture, "Done in {0} seconds.\nPress <Enter> to exit.", timer.ElapsedMilliseconds / 1000.0));
            Console.ReadLine();
#endif
        }

        static void Main()
        {
            new Solution().Start();
        }

        #endregion
    }
}

namespace kp.Algo { }


namespace kp.Algo.IO
{
public class Scanner : IDisposable
    {
        #region Fields

        readonly System.IO.TextReader _reader;
        readonly int _bufferSize;
        readonly bool _closeReader;
        readonly char[] _buffer;
        int _length, _pos;

        #endregion

        #region .ctors

        public Scanner( System.IO.TextReader reader, int bufferSize, bool closeReader )
        {
            _reader = reader;
            _bufferSize = bufferSize;
            _closeReader = closeReader;
            _buffer = new char[_bufferSize];
            FillBuffer( false );
        }

        public Scanner( System.IO.TextReader reader, bool closeReader ) : this( reader, 1 << 16, closeReader ) { }

        public Scanner( string fileName ) : this( new System.IO.StreamReader( fileName, System.Text.Encoding.Default ), true ) { }

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            if ( _closeReader )
            {
                _reader.Close();
            }
        }

        #endregion

        #region Properties

        public bool Eof
        {
            get
            {
                if ( _pos < _length ) return false;
                FillBuffer( false );
                return _pos >= _length;
            }
        }

        #endregion

        #region Methods

        private char NextChar()
        {
            if ( _pos < _length ) return _buffer[_pos++];
            FillBuffer( true );
            return _buffer[_pos++];
        }

        private char PeekNextChar()
        {
            if ( _pos < _length ) return _buffer[_pos];
            FillBuffer( true );
            return _buffer[_pos];
        }

        private void FillBuffer( bool throwOnEof )
        {
            _length = _reader.Read( _buffer, 0, _bufferSize );
            if ( throwOnEof && Eof )
            {
                throw new System.IO.IOException( "Can't read beyond the end of file" );
            }
            _pos = 0;
        }

        public int NextInt()
        {
            var neg = false;
            int res = 0;
            SkipWhitespaces();
            if ( !Eof && PeekNextChar() == '-' )
            {
                neg = true;
                _pos++;
            }
            while ( !Eof && !IsWhitespace( PeekNextChar() ) )
            {
                var c = NextChar();
                if ( c < '0' || c > '9' ) throw new ArgumentException( "Illegal character" );
                res = 10 * res + c - '0';
            }
            return neg ? -res : res;
        }

        public int[] NextIntArray( int n )
        {
            var res = new int[n];
            for ( int i = 0; i < n; i++ )
            {
                res[i] = NextInt();
            }
            return res;
        }

        public long NextLong()
        {
            var neg = false;
            long res = 0;
            SkipWhitespaces();
            if ( !Eof && PeekNextChar() == '-' )
            {
                neg = true;
                _pos++;
            }
            while ( !Eof && !IsWhitespace( PeekNextChar() ) )
            {
                var c = NextChar();
                if ( c < '0' || c > '9' ) throw new ArgumentException( "Illegal character" );
                res = 10 * res + c - '0';
            }
            return neg ? -res : res;
        }

        public long[] NextLongArray( int n )
        {
            var res = new long[n];
            for ( int i = 0; i < n; i++ )
            {
                res[i] = NextLong();
            }
            return res;
        }

        public string NextLine()
        {
            SkipUntilNextLine();
            if ( Eof ) return "";
            var builder = new System.Text.StringBuilder();
            while ( !Eof && !IsEndOfLine( PeekNextChar() ) )
            {
                builder.Append( NextChar() );
            }
            return builder.ToString();
        }

        public double NextDouble()
        {
            SkipWhitespaces();
            var builder = new System.Text.StringBuilder();
            while ( !Eof && !IsWhitespace( PeekNextChar() ) )
            {
                builder.Append( NextChar() );
            }
            return double.Parse( builder.ToString(), System.Globalization.CultureInfo.InvariantCulture );
        }

        public double[] NextDoubleArray( int n )
        {
            var res = new double[n];
            for ( int i = 0; i < n; i++ )
            {
                res[i] = NextDouble();
            }
            return res;
        }

        public string NextToken()
        {
            SkipWhitespaces();
            var builder = new System.Text.StringBuilder();
            while ( !Eof && !IsWhitespace( PeekNextChar() ) )
            {
                builder.Append( NextChar() );
            }
            return builder.ToString();
        }

        private void SkipWhitespaces()
        {
            while ( !Eof && IsWhitespace( PeekNextChar() ) )
            {
                ++_pos;
            }
        }

        private void SkipUntilNextLine()
        {
            while ( !Eof && IsEndOfLine( PeekNextChar() ) )
            {
                ++_pos;
            }
        }

        private static bool IsWhitespace( char c )
        {
            return c == ' ' || c == '\t' || c == '\n' || c == '\r';
        }

        private static bool IsEndOfLine( char c )
        {
            return c == '\n' || c == '\r';
        }

        #endregion
    }
}